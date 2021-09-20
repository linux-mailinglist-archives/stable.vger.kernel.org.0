Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F67F41210F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356753AbhITSB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355970AbhITR5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E4A663210;
        Mon, 20 Sep 2021 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158090;
        bh=uLgFZxX+cwiet4pUq59oiyiXdrCWvxBD5wFY6RaxJxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0l1uxWC7EGXMRsePQn+1swjj1j5YwfcXzxpm4BBkxszGlE3QXGe5Yrifao+xVPU7
         U7MK0PolRUgFjsIrgoZ+sE00CINCsFGZ0vdDs4b6tLDujR8ynNriD/yFyymX/SvLgI
         XORZS1X+HlM2VlgjNsyp6A341B/Z1SqzcQnxHBRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 291/293] qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom
Date:   Mon, 20 Sep 2021 18:44:13 +0200
Message-Id: <20210920163943.389512622@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 9ddbc2a00d7f63fa9748f4278643193dac985f2d ]

Previous commit 68233c583ab4 removes the qlcnic_rom_lock()
in qlcnic_pinit_from_rom(), but remains its corresponding
unlock function, which is odd. I'm not very sure whether the
lock is missing, or the unlock is redundant. This bug is
suggested by a static analysis tool, please advise.

Fixes: 68233c583ab4 ("qlcnic: updated reset sequence")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
index c48a0e2d4d7e..6a009d51ec51 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
@@ -440,7 +440,6 @@ int qlcnic_pinit_from_rom(struct qlcnic_adapter *adapter)
 	QLCWR32(adapter, QLCNIC_CRB_PEG_NET_4 + 0x3c, 1);
 	msleep(20);
 
-	qlcnic_rom_unlock(adapter);
 	/* big hammer don't reset CAM block on reset */
 	QLCWR32(adapter, QLCNIC_ROMUSB_GLB_SW_RESET, 0xfeffffff);
 
-- 
2.30.2



