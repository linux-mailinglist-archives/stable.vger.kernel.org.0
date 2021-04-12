Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B68435BDDE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbhDLIz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238489AbhDLIw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:52:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C88D61245;
        Mon, 12 Apr 2021 08:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217482;
        bh=ddeWvEfMLZhZTY/Tnhr98pgZHnNWStXT2gqnkV1AjrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AV+aY6vSTdXnh6EdU8W11HRdIXWtPOZuHpnTNa2ZbVZGBj+Ebn0ZpHnskhF9giy64
         zPOXo6QGAYyrr4uFD2Ja0agLui2Vp2fYsUmd3zUv/G4vCiW3SflKkPMnVNsrlsAtKf
         28FClVEVljkqGUJEFK98LzbFJxxsVepyhgz3vyXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 032/188] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
Date:   Mon, 12 Apr 2021 10:39:06 +0200
Message-Id: <20210412084014.719784989@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 08c27f3322fec11950b8f1384aa0f3b11d028528 upstream.

KMSAN found uninitialized value at batadv_tt_prepare_tvlv_local_data()
[1], for commit ced72933a5e8ab52 ("batman-adv: use CRC32C instead of CRC16
in TT code") inserted 'reserved' field into "struct batadv_tvlv_tt_data"
and commit 7ea7b4a142758dea ("batman-adv: make the TT CRC logic VLAN
specific") moved that field to "struct batadv_tvlv_tt_vlan_data" but left
that field uninitialized.

[1] https://syzkaller.appspot.com/bug?id=07f3e6dba96f0eb3cabab986adcd8a58b9bdbe9d

Reported-by: syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: ced72933a5e8ab52 ("batman-adv: use CRC32C instead of CRC16 in TT code")
Fixes: 7ea7b4a142758dea ("batman-adv: make the TT CRC logic VLAN specific")
Acked-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -891,6 +891,7 @@ batadv_tt_prepare_tvlv_global_data(struc
 	hlist_for_each_entry(vlan, &orig_node->vlan_list, list) {
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
+		tt_vlan->reserved = 0;
 
 		tt_vlan++;
 	}
@@ -974,6 +975,7 @@ batadv_tt_prepare_tvlv_local_data(struct
 
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
+		tt_vlan->reserved = 0;
 
 		tt_vlan++;
 	}


