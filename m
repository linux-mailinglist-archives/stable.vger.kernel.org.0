Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4572411DB7
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfEBPci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729222AbfEBPch (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5CCD20C01;
        Thu,  2 May 2019 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811157;
        bh=k4+S0ew6Ouj4ybxeRKaDzF9S1RhQIjIaFrWOyEUVUB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yqb154dsDWR2g8WIzy5UEiQ6NlIq3eG/vDJ+I2u9U6yDIbQWazTV8QND4y6fjr9Ac
         jxJltvnJ0uz68Vd/Ix3YIvlF3mKnpKC0bQKXZFeEq2OSRtT+J4mhgzXhU2IqIjxzYn
         mIzoB+JJBRdHeGtJnMbwVWMRa7gDMoMd/aX2Z5bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 096/101] kconfig/[mn]conf: handle backspace (^H) key
Date:   Thu,  2 May 2019 17:21:38 +0200
Message-Id: <20190502143346.293306876@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9c38f1f044080392603c497ecca4d7d09876ff99 ]

Backspace is not working on some terminal emulators which do not send the
key code defined by terminfo. Terminals either send '^H' (8) or '^?' (127).
But currently only '^?' is handled. Let's also handle '^H' for those
terminals.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 scripts/kconfig/lxdialog/inputbox.c | 3 ++-
 scripts/kconfig/nconf.c             | 2 +-
 scripts/kconfig/nconf.gui.c         | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index 611945611bf8..1dcfb288ee63 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -113,7 +113,8 @@ int dialog_inputbox(const char *title, const char *prompt, int height, int width
 			case KEY_DOWN:
 				break;
 			case KEY_BACKSPACE:
-			case 127:
+			case 8:   /* ^H */
+			case 127: /* ^? */
 				if (pos) {
 					wattrset(dialog, dlg.inputbox.atr);
 					if (input_x == 0) {
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index a4670f4e825a..ac92c0ded6c5 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1048,7 +1048,7 @@ static int do_match(int key, struct match_state *state, int *ans)
 		state->match_direction = FIND_NEXT_MATCH_UP;
 		*ans = get_mext_match(state->pattern,
 				state->match_direction);
-	} else if (key == KEY_BACKSPACE || key == 127) {
+	} else if (key == KEY_BACKSPACE || key == 8 || key == 127) {
 		state->pattern[strlen(state->pattern)-1] = '\0';
 		adj_match_dir(&state->match_direction);
 	} else
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 7be620a1fcdb..77f525a8617c 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -439,7 +439,8 @@ int dialog_inputbox(WINDOW *main_window,
 		case KEY_F(F_EXIT):
 		case KEY_F(F_BACK):
 			break;
-		case 127:
+		case 8:   /* ^H */
+		case 127: /* ^? */
 		case KEY_BACKSPACE:
 			if (cursor_position > 0) {
 				memmove(&result[cursor_position-1],
-- 
2.19.1



