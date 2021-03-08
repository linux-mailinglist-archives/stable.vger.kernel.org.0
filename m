Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977B6330E03
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhCHMes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230510AbhCHMeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:34:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA89865203;
        Mon,  8 Mar 2021 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206859;
        bh=QtfgpEbjnnt/6dA/dFPtbmehdAcvax97J26PQe0phFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtLGVsaQAgHWglPYw51f2WV1BKtTbRMdmSl26zz+ZyATuCwj6wK2U8oonRdOENkfP
         na6m2J5PhKS+7idnFBy1LnvI1mRgkY1MOxSQMVEczE2cX5cI6luPypEVuiMhcuHiVO
         cqH1OGj2DfXVW2k8r3XQtqdZuCODx5Sz/aiNE6fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/42] ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits
Date:   Mon,  8 Mar 2021 13:30:57 +0100
Message-Id: <20210308122719.652039636@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 26a9630c72ebac7c564db305a6aee54a8edde70e ]

Currently the mask operation on variable conf is just 3 bits so
the switch statement case value of 8 is unreachable dead code.
The function daio_mgr_dao_init can be passed a 4 bit value,
function dao_rsc_init calls it with conf set to:

     conf = (desc->msr & 0x7) | (desc->passthru << 3);

so clearly when desc->passthru is set to 1 then conf can be
at least 8.

Fix this by changing the mask to 0xf.

Fixes: 8cc72361481f ("ALSA: SB X-Fi driver merge")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210227001527.1077484-1-colin.king@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ctxfi/cthw20k2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index fc1bc18caee9..85d1fc76f59e 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -991,7 +991,7 @@ static int daio_mgr_dao_init(void *blk, unsigned int idx, unsigned int conf)
 
 	if (idx < 4) {
 		/* S/PDIF output */
-		switch ((conf & 0x7)) {
+		switch ((conf & 0xf)) {
 		case 1:
 			set_field(&ctl->txctl[idx], ATXCTL_NUC, 0);
 			break;
-- 
2.30.1



