Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345F91880FA
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgCQLMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729460AbgCQLMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:12:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A64F206EC;
        Tue, 17 Mar 2020 11:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443565;
        bh=6Ht9hRcQ3x8A/4aWNjgCjoKSWvdw+u4LLN81XdYlhHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f299bMb9V4brqm3+uLvbwMIwENok/KBD8/wcm6zOo9IJBLKP1lmHJDrk88IeC9hst
         6HL/xZsrk0+LxdwbainhxsEzNHAcy/aU5Dvg+9S21PniQYuP5BG0fiTe+wGzcPDKU9
         qUczR5MBywForF8sltRD2eowijZ7ObIcyKxj6HtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com,
        syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com,
        Sven Eckelmann <sven@narfation.org>,
        Hillf Danton <hdanton@sina.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.5 124/151] batman-adv: Dont schedule OGM for disabled interface
Date:   Tue, 17 Mar 2020 11:55:34 +0100
Message-Id: <20200317103335.262073922@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 8e8ce08198de193e3d21d42e96945216e3d9ac7f upstream.

A transmission scheduling for an interface which is currently dropped by
batadv_iv_ogm_iface_disable could still be in progress. The B.A.T.M.A.N. V
is simply cancelling the workqueue item in an synchronous way but this is
not possible with B.A.T.M.A.N. IV because the OGM submissions are
intertwined.

Instead it has to stop submitting the OGM when it detect that the buffer
pointer is set to NULL.

Reported-by: syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com
Reported-by: syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/bat_iv_ogm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -789,6 +789,10 @@ static void batadv_iv_ogm_schedule_buff(
 
 	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
 
+	/* interface already disabled by batadv_iv_ogm_iface_disable */
+	if (!*ogm_buff)
+		return;
+
 	/* the interface gets activated here to avoid race conditions between
 	 * the moment of activating the interface in
 	 * hardif_activate_interface() where the originator mac is set and


