Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C1B66C55F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjAPQFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbjAPQE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:04:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67752410C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69557B80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8093C433F0;
        Mon, 16 Jan 2023 16:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884995;
        bh=69t2bdjOS+7RBEE+s/cEdTXDu49Bwlf/my39Dl5z8Wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5Pekvxzs31QYXduG2i9C9yxAoy/N/GDrzDSrumG2LF+fkfHHfjDxX73VDxea75tN
         Oi1Xa7dqm2sSpHWml31RI5Dd3hU7Uzsha1joNuM1eBXoo7WMZzPV2gEoUMl9BJHGYj
         UnKUj1wOx4LJhvFwQjNBPWgENb9av/0EzoKhb+Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.15 09/86] docs: Fix the docs build with Sphinx 6.0
Date:   Mon, 16 Jan 2023 16:50:43 +0100
Message-Id: <20230116154747.447602691@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>

commit 0283189e8f3d0917e2ac399688df85211f48447b upstream.

Sphinx 6.0 removed the execfile_() function, which we use as part of the
configuration process.  They *did* warn us...  Just open-code the
functionality as is done in Sphinx itself.

Tested (using SPHINX_CONF, since this code is only executed with an
alternative config file) on various Sphinx versions from 2.5 through 6.0.

Reported-by: Martin Liška <mliska@suse.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/load_config.py |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/sphinx/load_config.py
+++ b/Documentation/sphinx/load_config.py
@@ -3,7 +3,7 @@
 
 import os
 import sys
-from sphinx.util.pycompat import execfile_
+from sphinx.util.osutil import fs_encoding
 
 # ------------------------------------------------------------------------------
 def loadConfig(namespace):
@@ -48,7 +48,9 @@ def loadConfig(namespace):
             sys.stdout.write("load additional sphinx-config: %s\n" % config_file)
             config = namespace.copy()
             config['__file__'] = config_file
-            execfile_(config_file, config)
+            with open(config_file, 'rb') as f:
+                code = compile(f.read(), fs_encoding, 'exec')
+                exec(code, config)
             del config['__file__']
             namespace.update(config)
         else:


