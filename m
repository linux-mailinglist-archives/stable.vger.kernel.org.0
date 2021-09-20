Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AAD4124A3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245223AbhITSgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380559AbhITSe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A43A363307;
        Mon, 20 Sep 2021 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158903;
        bh=b/rRNjwkpOX6ShPOUdeXpzNgnbvmGEbOzQ6Xy+tOEmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yX7Gk/2nLYE99AIrM6nV5RpBvOh0pOKU346yHLkzbRAFoey4No+/e3wiy8iqWWtn5
         M0JOBVp55eSPMMzJ/JfAdn66dEfWIZYZTuPYXEmY3wcciL7zV4ZkJTrjh83SdxamvD
         SS/1HRX04PUEWs3OMj4ZWTNm0toGIfieEdxv5jT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/122] qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom
Date:   Mon, 20 Sep 2021 18:44:41 +0200
Message-Id: <20210920163919.382030040@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
index e6784023bce4..aa7ee43f9252 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c
@@ -439,7 +439,6 @@ int qlcnic_pinit_from_rom(struct qlcnic_adapter *adapter)
 	QLCWR32(adapter, QLCNIC_CRB_PEG_NET_4 + 0x3c, 1);
 	msleep(20);
 
-	qlcnic_rom_unlock(adapter);
 	/* big hammer don't reset CAM block on reset */
 	QLCWR32(adapter, QLCNIC_ROMUSB_GLB_SW_RESET, 0xfeffffff);
 
-- 
2.30.2



