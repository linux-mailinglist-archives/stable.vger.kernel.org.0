Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C693D0E3F
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 13:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbhGULQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 07:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237492AbhGUKxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 06:53:07 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E569C0617A6;
        Wed, 21 Jul 2021 04:33:20 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c1so1969666pfc.13;
        Wed, 21 Jul 2021 04:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NSUIN6maeq33hi7ZKUpLjEr+OnEnHzB7GGqa1HE5xpI=;
        b=rKtYaN6uHhE+6arpZ8JEhrQ0rKg5OGSG49zDKPGDn6ewn3vVVOU+gS8yrT4OrY5XOD
         X2W0Fsnf14jozXP85iRQ5PXh17qi91jmaKLTmyRSLVBJJTG6uneTc1FgUkSTXUsIX0xt
         P/WzfJvabqjl+v4puXKQY/HcqlOQyz3JqIAxsZfRWy3WiEt2RGK3LcIkfKKNJ+qOx+Qb
         rcoD8UiLFLWwEJ6PDpPNVtG6FzWHBhPPRXU/5uuKPpc49t/q5pnfw/Al89gXJW5DtI7L
         PBBqky+AlkloESHGVhaPHsupJASQiR1ZH4H/o+tiN1ivqgJv/N1KbIviG5bboGAbqxur
         E2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NSUIN6maeq33hi7ZKUpLjEr+OnEnHzB7GGqa1HE5xpI=;
        b=e1r36PcT7p9TBnXyKh+PPaalQ9F+k2Zls6D8dzNyYsNYX0psL5i1vaYFkEa0Vuifkp
         IAB2t/83RIaloULtgjmWXOYOjyAgvahfjOZ1exMHdLk+N1lm6OZBIWiF2jSspY376wtL
         Q2EoyU0NOoDirEoNbzLoaZ4N2A5+hOrNQ4FYvwji5neqFbPw0uaGhx9DxEUvFKujGMKh
         xL/OYXxBjNTZz500TwHfLiIEVgYjEM6qBqwAD5NVsi8mU3B8fxjAiYxvidcs6i88kaJG
         JwsOoB8Rq/c9aRa94IeTfNM4tFx4Y86yMloWz+V68NDvt5OOeI11o1v3weyJkXmI6WBL
         1O3g==
X-Gm-Message-State: AOAM531l35OLrp6B6CtH5XkpCnpCYWC2uQFDcgN3U4lmTwMoQO22KGIO
        RVgl3QQor/apl1gvD5YZus8=
X-Google-Smtp-Source: ABdhPJwLj0l9eo4EBnkxaa056AdGouV+sF1Br3L5ZLWKFCH4zDhMoQ1gKtowgb/tPFT8psT5dAt70g==
X-Received: by 2002:a63:2cd2:: with SMTP id s201mr30423917pgs.119.1626867199843;
        Wed, 21 Jul 2021 04:33:19 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.166])
        by smtp.gmail.com with ESMTPSA id c7sm28730171pgq.22.2021.07.21.04.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 04:33:19 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] tty: nozomi: tty_unregister_device -> tty_port_unregister_device
Date:   Wed, 21 Jul 2021 19:33:04 +0800
Message-Id: <20210721113305.1524059-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pairwise api invocation of tty_port_register_device should be
tty_port_unregister_device, other than tty_unregister_device.

Fixes: a6afd9f3e819 ("tty: move a number of tty drivers from drivers/char/ to drivers/tty/")
Cc: stable@vger.kernel.org
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/tty/nozomi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index 0c80f25c8c3d..08bdd82f60b5 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1417,7 +1417,8 @@ static int nozomi_card_init(struct pci_dev *pdev,
 
 err_free_tty:
 	for (i--; i >= 0; i--) {
-		tty_unregister_device(ntty_driver, dc->index_start + i);
+		tty_port_unregister_device(&dc->port[i].port, ntty_driver,
+				dc->index_start + i);
 		tty_port_destroy(&dc->port[i].port);
 	}
 	free_irq(pdev->irq, dc);
-- 
2.25.1

