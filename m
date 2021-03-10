Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35837333EAE
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhCJN0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233313AbhCJNZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9ADD6504F;
        Wed, 10 Mar 2021 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382720;
        bh=ZjTosE1btrgNQ9yia2PYQqA6APnbfePX61NsH64nF20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTz6+XAWwY+OHDCEUrc0+aG3WxZwDBuJWRhJfkHeDIsJr3jgsTVTefkSg109ZPePL
         hxJKbyO6Dqswnq+PbD4imdGuyJZi4H91LzpbClCMzvDpkm0HswrSNsARUmu3oBHYqt
         6uLeA3jhL67eVYsRFvwXlP1YYWryQuoCZSWiBW4A=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/39] ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits
Date:   Wed, 10 Mar 2021 14:24:24 +0100
Message-Id: <20210310132320.236653992@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index 3c966fafc754..6c9ab602212e 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -995,7 +995,7 @@ static int daio_mgr_dao_init(void *blk, unsigned int idx, unsigned int conf)
 
 	if (idx < 4) {
 		/* S/PDIF output */
-		switch ((conf & 0x7)) {
+		switch ((conf & 0xf)) {
 		case 1:
 			set_field(&ctl->txctl[idx], ATXCTL_NUC, 0);
 			break;
-- 
2.30.1



