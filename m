Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BC55AB0A3
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbiIBMyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbiIBMxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2122FAC5C;
        Fri,  2 Sep 2022 05:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E94E3621AD;
        Fri,  2 Sep 2022 12:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF27AC43140;
        Fri,  2 Sep 2022 12:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122139;
        bh=Tcnr0M/+JklF6IJ1Gko6tigbWpUs6RoHLcVvYm7plkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJhCwAM1uCTevyy2LEfnjos0qiZz58eKkkj8CKiqaczma1Ij0QuJWtZzdMxRayzBq
         U2qgqDlBRyLpc/Y0dq04AchU2+RuIwAXTvQXU2+tdILWR5QYEJCg3F8UiO9DRZQO0D
         hllW0fH42pr1mw8c4TdZvRe4WYy4ZVJZsapX40ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akira Yokosawa <akiyks@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.19 05/72] docs: kerneldoc-preamble: Test xeCJK.sty before loading
Date:   Fri,  2 Sep 2022 14:18:41 +0200
Message-Id: <20220902121404.960927228@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akira Yokosawa <akiyks@gmail.com>

commit cee7db1b0239468b22c295cf04a8c40c34ecd35a upstream.

On distros whose texlive packaging is fine-grained, texlive-xecjk
can be installed/removed independently of other texlive packages.
Conditionally loading xeCJK depending only on the existence of the
"Noto Sans CJK SC" font might end up in xelatex error of
"xeCJK.sty not found!".

Improve the situation by testing existence of xeCJK.sty before
loading it.

This is useful on RHEL 9 and its clone distros where texlive-xecjk
doesn't work at the moment due to a missing dependency [1].
"make pdfdocs" for non-CJK contents should work after removing
texlive-xecjk.

Link: [1] https://bugzilla.redhat.com/show_bug.cgi?id=2086254
Fixes: 398f7abdcb7e ("docs: pdfdocs: Pull LaTeX preamble part out of conf.py")
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Link: https://lore.kernel.org/r/c24c2a87-70b2-5342-bcc9-de467940466e@gmail.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/kerneldoc-preamble.sty | 22 +++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/Documentation/sphinx/kerneldoc-preamble.sty b/Documentation/sphinx/kerneldoc-preamble.sty
index 2a29cbe51396..9707e033c8c4 100644
--- a/Documentation/sphinx/kerneldoc-preamble.sty
+++ b/Documentation/sphinx/kerneldoc-preamble.sty
@@ -70,8 +70,16 @@
 
 % Translations have Asian (CJK) characters which are only displayed if
 % xeCJK is used
+\usepackage{ifthen}
+\newboolean{enablecjk}
+\setboolean{enablecjk}{false}
 \IfFontExistsTF{Noto Sans CJK SC}{
-    % Load xeCJK when CJK font is available
+    \IfFileExists{xeCJK.sty}{
+	\setboolean{enablecjk}{true}
+    }{}
+}{}
+\ifthenelse{\boolean{enablecjk}}{
+    % Load xeCJK when both the Noto Sans CJK font and xeCJK.sty are available.
     \usepackage{xeCJK}
     % Noto CJK fonts don't provide slant shape. [AutoFakeSlant] permits
     % its emulation.
@@ -196,7 +204,7 @@
     % Inactivate CJK after tableofcontents
     \apptocmd{\sphinxtableofcontents}{\kerneldocCJKoff}{}{}
     \xeCJKsetup{CJKspace = true}% For inter-phrase space of Korean TOC
-}{ % No CJK font found
+}{ % Don't enable CJK
     % Custom macros to on/off CJK and switch CJK fonts (Dummy)
     \newcommand{\kerneldocCJKon}{}
     \newcommand{\kerneldocCJKoff}{}
@@ -204,14 +212,16 @@
     %% and ignore the argument (#1) in their definitions, whole contents of
     %% CJK chapters can be ignored.
     \newcommand{\kerneldocBeginSC}[1]{%
-	%% Put a note on missing CJK fonts in place of zh_CN translation.
-	\begin{sphinxadmonition}{note}{Note on missing fonts:}
+	%% Put a note on missing CJK fonts or the xecjk package in place of
+	%% zh_CN translation.
+	\begin{sphinxadmonition}{note}{Note on missing fonts and a package:}
 	    Translations of Simplified Chinese (zh\_CN), Traditional Chinese
 	    (zh\_TW), Korean (ko\_KR), and Japanese (ja\_JP) were skipped
-	    due to the lack of suitable font families.
+	    due to the lack of suitable font families and/or the texlive-xecjk
+	    package.
 
 	    If you want them, please install ``Noto Sans CJK'' font families
-	    by following instructions from
+	    along with the texlive-xecjk package by following instructions from
 	    \sphinxcode{./scripts/sphinx-pre-install}.
 	    Having optional ``Noto Serif CJK'' font families will improve
 	    the looks of those translations.
-- 
2.37.2



