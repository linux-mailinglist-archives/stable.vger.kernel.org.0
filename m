Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D055739024
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbfFGPt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731952AbfFGPt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:49:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5084D20657;
        Fri,  7 Jun 2019 15:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922564;
        bh=EUlbzP8U0YE76e/2CHIcoq9TFF6XU6wNf6zR9WXMfZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6yhDrYu7zGzRkD7JWAx+9S2TWKNj6HnllmpZhmFWQhPYHka9XAtjSrPT/DzvF4+W
         xHGQJpZcYegx94tFk9PyAZT0ZGzzSgsN+3jpmC9G8spq/1CCxSUc4xOTPwtd1NL5Q7
         dG33pE5YGakDdOLnG/rDOTNTMQxGtqIWPmJ76Gs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.1 57/85] doc: Cope with Sphinx logging deprecations
Date:   Fri,  7 Jun 2019 17:39:42 +0200
Message-Id: <20190607153855.825739213@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>

commit 096ea522e84ea68f8e6c41e5e7294731a81e29bc upstream.

Recent versions of sphinx will emit messages like:

  Documentation/sphinx/kerneldoc.py:103:
     RemovedInSphinx20Warning: app.warning() is now deprecated.
     Use sphinx.util.logging instead.

Switch to sphinx.util.logging to make this unsightly message go away.
Alas, that interface was only added in version 1.6, so we have to add a
version check to keep things working with older sphinxes.

Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/sphinx/kerneldoc.py |   12 +++++++----
 Documentation/sphinx/kernellog.py |   28 ++++++++++++++++++++++++++
 Documentation/sphinx/kfigure.py   |   40 +++++++++++++++++++++-----------------
 3 files changed, 59 insertions(+), 21 deletions(-)

--- a/Documentation/sphinx/kerneldoc.py
+++ b/Documentation/sphinx/kerneldoc.py
@@ -49,6 +49,8 @@ if Use_SSI:
 else:
     from sphinx.ext.autodoc import AutodocReporter
 
+import kernellog
+
 __version__  = '1.0'
 
 class KernelDocDirective(Directive):
@@ -100,7 +102,8 @@ class KernelDocDirective(Directive):
         cmd += [filename]
 
         try:
-            env.app.verbose('calling kernel-doc \'%s\'' % (" ".join(cmd)))
+            kernellog.verbose(env.app,
+                              'calling kernel-doc \'%s\'' % (" ".join(cmd)))
 
             p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
             out, err = p.communicate()
@@ -110,7 +113,8 @@ class KernelDocDirective(Directive):
             if p.returncode != 0:
                 sys.stderr.write(err)
 
-                env.app.warn('kernel-doc \'%s\' failed with return code %d' % (" ".join(cmd), p.returncode))
+                kernellog.warn(env.app,
+                               'kernel-doc \'%s\' failed with return code %d' % (" ".join(cmd), p.returncode))
                 return [nodes.error(None, nodes.paragraph(text = "kernel-doc missing"))]
             elif env.config.kerneldoc_verbosity > 0:
                 sys.stderr.write(err)
@@ -136,8 +140,8 @@ class KernelDocDirective(Directive):
             return node.children
 
         except Exception as e:  # pylint: disable=W0703
-            env.app.warn('kernel-doc \'%s\' processing failed with: %s' %
-                         (" ".join(cmd), str(e)))
+            kernellog.warn(env.app, 'kernel-doc \'%s\' processing failed with: %s' %
+                           (" ".join(cmd), str(e)))
             return [nodes.error(None, nodes.paragraph(text = "kernel-doc missing"))]
 
     def do_parse(self, result, node):
--- /dev/null
+++ b/Documentation/sphinx/kernellog.py
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Sphinx has deprecated its older logging interface, but the replacement
+# only goes back to 1.6.  So here's a wrapper layer to keep around for
+# as long as we support 1.4.
+#
+import sphinx
+
+if sphinx.__version__[:3] >= '1.6':
+    UseLogging = True
+    from sphinx.util import logging
+    logger = logging.getLogger('kerneldoc')
+else:
+    UseLogging = False
+
+def warn(app, message):
+    if UseLogging:
+        logger.warning(message)
+    else:
+        app.warn(message)
+
+def verbose(app, message):
+    if UseLogging:
+        logger.verbose(message)
+    else:
+        app.verbose(message)
+
+
--- a/Documentation/sphinx/kfigure.py
+++ b/Documentation/sphinx/kfigure.py
@@ -60,6 +60,8 @@ import sphinx
 from sphinx.util.nodes import clean_astext
 from six import iteritems
 
+import kernellog
+
 PY3 = sys.version_info[0] == 3
 
 if PY3:
@@ -171,20 +173,20 @@ def setupTools(app):
     This function is called once, when the builder is initiated.
     """
     global dot_cmd, convert_cmd   # pylint: disable=W0603
-    app.verbose("kfigure: check installed tools ...")
+    kernellog.verbose(app, "kfigure: check installed tools ...")
 
     dot_cmd = which('dot')
     convert_cmd = which('convert')
 
     if dot_cmd:
-        app.verbose("use dot(1) from: " + dot_cmd)
+        kernellog.verbose(app, "use dot(1) from: " + dot_cmd)
     else:
-        app.warn("dot(1) not found, for better output quality install "
-                 "graphviz from http://www.graphviz.org")
+        kernellog.warn(app, "dot(1) not found, for better output quality install "
+                       "graphviz from http://www.graphviz.org")
     if convert_cmd:
-        app.verbose("use convert(1) from: " + convert_cmd)
+        kernellog.verbose(app, "use convert(1) from: " + convert_cmd)
     else:
-        app.warn(
+        kernellog.warn(app,
             "convert(1) not found, for SVG to PDF conversion install "
             "ImageMagick (https://www.imagemagick.org)")
 
@@ -220,12 +222,13 @@ def convert_image(img_node, translator,
 
     # in kernel builds, use 'make SPHINXOPTS=-v' to see verbose messages
 
-    app.verbose('assert best format for: ' + img_node['uri'])
+    kernellog.verbose(app, 'assert best format for: ' + img_node['uri'])
 
     if in_ext == '.dot':
 
         if not dot_cmd:
-            app.verbose("dot from graphviz not available / include DOT raw.")
+            kernellog.verbose(app,
+                              "dot from graphviz not available / include DOT raw.")
             img_node.replace_self(file2literal(src_fname))
 
         elif translator.builder.format == 'latex':
@@ -252,7 +255,8 @@ def convert_image(img_node, translator,
 
         if translator.builder.format == 'latex':
             if convert_cmd is None:
-                app.verbose("no SVG to PDF conversion available / include SVG raw.")
+                kernellog.verbose(app,
+                                  "no SVG to PDF conversion available / include SVG raw.")
                 img_node.replace_self(file2literal(src_fname))
             else:
                 dst_fname = path.join(translator.builder.outdir, fname + '.pdf')
@@ -265,18 +269,19 @@ def convert_image(img_node, translator,
         _name = dst_fname[len(translator.builder.outdir) + 1:]
 
         if isNewer(dst_fname, src_fname):
-            app.verbose("convert: {out}/%s already exists and is newer" % _name)
+            kernellog.verbose(app,
+                              "convert: {out}/%s already exists and is newer" % _name)
 
         else:
             ok = False
             mkdir(path.dirname(dst_fname))
 
             if in_ext == '.dot':
-                app.verbose('convert DOT to: {out}/' + _name)
+                kernellog.verbose(app, 'convert DOT to: {out}/' + _name)
                 ok = dot2format(app, src_fname, dst_fname)
 
             elif in_ext == '.svg':
-                app.verbose('convert SVG to: {out}/' + _name)
+                kernellog.verbose(app, 'convert SVG to: {out}/' + _name)
                 ok = svg2pdf(app, src_fname, dst_fname)
 
             if not ok:
@@ -305,7 +310,8 @@ def dot2format(app, dot_fname, out_fname
     with open(out_fname, "w") as out:
         exit_code = subprocess.call(cmd, stdout = out)
         if exit_code != 0:
-            app.warn("Error #%d when calling: %s" % (exit_code, " ".join(cmd)))
+            kernellog.warn(app,
+                          "Error #%d when calling: %s" % (exit_code, " ".join(cmd)))
     return bool(exit_code == 0)
 
 def svg2pdf(app, svg_fname, pdf_fname):
@@ -322,7 +328,7 @@ def svg2pdf(app, svg_fname, pdf_fname):
     # use stdout and stderr from parent
     exit_code = subprocess.call(cmd)
     if exit_code != 0:
-        app.warn("Error #%d when calling: %s" % (exit_code, " ".join(cmd)))
+        kernellog.warn(app, "Error #%d when calling: %s" % (exit_code, " ".join(cmd)))
     return bool(exit_code == 0)
 
 
@@ -415,15 +421,15 @@ def visit_kernel_render(self, node):
     app = self.builder.app
     srclang = node.get('srclang')
 
-    app.verbose('visit kernel-render node lang: "%s"' % (srclang))
+    kernellog.verbose(app, 'visit kernel-render node lang: "%s"' % (srclang))
 
     tmp_ext = RENDER_MARKUP_EXT.get(srclang, None)
     if tmp_ext is None:
-        app.warn('kernel-render: "%s" unknown / include raw.' % (srclang))
+        kernellog.warn(app, 'kernel-render: "%s" unknown / include raw.' % (srclang))
         return
 
     if not dot_cmd and tmp_ext == '.dot':
-        app.verbose("dot from graphviz not available / include raw.")
+        kernellog.verbose(app, "dot from graphviz not available / include raw.")
         return
 
     literal_block = node[0]


