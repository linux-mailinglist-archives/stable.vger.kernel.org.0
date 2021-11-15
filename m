Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607CE45112B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243616AbhKOTBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243377AbhKOS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C73A63489;
        Mon, 15 Nov 2021 18:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999974;
        bh=aRX11VJF9BLb4MYs6Cv19lJvEmOI7rU37ghhaJFr7TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQhDsZg9S7NTfDNUPcKxyZG5WWLiogb1+CxzeEZ+oT9/lnuexuQFw93p9boW7nsn2
         8Lbzz3C7juKPu8gFAKYWpQ4FlZb8yTG0obAgVEN8fc2g9h0B/7k9mNDVQ+hyoFwlaU
         sOZybxf0PbJ/dH8wXGytAyzuefm3QieXVVDU9fv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+93dba5b91f0fed312cbd@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 490/849] smackfs: use netlbl_cfg_cipsov4_del() for deleting cipso_v4_doi
Date:   Mon, 15 Nov 2021 17:59:33 +0100
Message-Id: <20211115165436.859359304@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit 0934ad42bb2c5df90a1b9de690f93de735b622fe ]

syzbot is reporting UAF at cipso_v4_doi_search() [1], for smk_cipso_doi()
is calling kfree() without removing from the cipso_v4_doi_list list after
netlbl_cfg_cipsov4_map_add() returned an error. We need to use
netlbl_cfg_cipsov4_del() in order to remove from the list and wait for
RCU grace period before kfree().

Link: https://syzkaller.appspot.com/bug?extid=93dba5b91f0fed312cbd [1]
Reported-by: syzbot <syzbot+93dba5b91f0fed312cbd@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 6c2e8ac0953fccdd ("netlabel: Update kernel configuration API")
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 89989d28ffc55..658eab05599e6 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -712,7 +712,7 @@ static void smk_cipso_doi(void)
 	if (rc != 0) {
 		printk(KERN_WARNING "%s:%d map add rc = %d\n",
 		       __func__, __LINE__, rc);
-		kfree(doip);
+		netlbl_cfg_cipsov4_del(doip->doi, &nai);
 		return;
 	}
 }
-- 
2.33.0



