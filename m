Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4231D0C9E
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732595AbgEMJqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732603AbgEMJqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0130220753;
        Wed, 13 May 2020 09:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363176;
        bh=iS7eAURgS/wF/PWdxHp0Cl49YaiEufuniPsH1gRlEeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhpS/NryXrl7/Rlp7r/0xJoCF3moDFTAWzJtqiBKi0cTamoFKVdemQ3Zaom9Q8BKk
         qEcm7FSOoy7+jM7J8M7jQ/cqnnHU5b0uxGt1iQf1/siG/wqlMjbTdTiyumJG5Ktykn
         RBP8fVCsbJ3SN2rmy6TykSA8sRf9dXROGmzpayKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        syzbot+0bfda3ade1ee9288a1be@syzkaller.appspotmail.com,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/48] vt: fix unicode console freeing with a common interface
Date:   Wed, 13 May 2020 11:44:29 +0200
Message-Id: <20200513094352.389302207@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Pitre <nico@fluxnic.net>

[ Upstream commit 57d38f26d81e4275748b69372f31df545dcd9b71 ]

By directly using kfree() in different places we risk missing one if
it is switched to using vfree(), especially if the corresponding
vmalloc() is hidden away within a common abstraction.

Oh wait, that's exactly what happened here.

So let's fix this by creating a common abstraction for the free case
as well.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Reported-by: syzbot+0bfda3ade1ee9288a1be@syzkaller.appspotmail.com
Fixes: 9a98e7a80f95 ("vt: don't use kmalloc() for the unicode screen buffer")
Cc: <stable@vger.kernel.org>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.2005021043110.2671@knanqh.ubzr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index ca8c6ddc1ca8c..5c7a968a5ea67 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -365,9 +365,14 @@ static struct uni_screen *vc_uniscr_alloc(unsigned int cols, unsigned int rows)
 	return uniscr;
 }
 
+static void vc_uniscr_free(struct uni_screen *uniscr)
+{
+	vfree(uniscr);
+}
+
 static void vc_uniscr_set(struct vc_data *vc, struct uni_screen *new_uniscr)
 {
-	vfree(vc->vc_uni_screen);
+	vc_uniscr_free(vc->vc_uni_screen);
 	vc->vc_uni_screen = new_uniscr;
 }
 
@@ -1233,7 +1238,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	err = resize_screen(vc, new_cols, new_rows, user);
 	if (err) {
 		kfree(newscreen);
-		kfree(new_uniscr);
+		vc_uniscr_free(new_uniscr);
 		return err;
 	}
 
-- 
2.20.1



