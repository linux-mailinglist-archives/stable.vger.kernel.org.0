Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BD735BFFE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhDLJIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238998AbhDLJG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9727461394;
        Mon, 12 Apr 2021 09:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218202;
        bh=mu82aaxhUSCv4teRdVd5Z/xs1BukO8EHJhQNZSEeNn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hw0JQDLWpYJH1xNxadEC1GEgTlsywVKY29nD0wfUjjiO0hZEqnfvhXw0uhTujvUYS
         LbHcYNR+w5GOA7pjbPN9FuyzKDQMf+iL/LkIxFfVrDPOq5Ma2RPFx40oAfAmtKHbbs
         sKAhfGZIg4D30H2S49dsp/az+AL3Qa9n12T3THcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 109/210] remoteproc: pru: Fix firmware loading crashes on K3 SoCs
Date:   Mon, 12 Apr 2021 10:40:14 +0200
Message-Id: <20210412084019.642767947@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

[ Upstream commit 9afeefcf06fc7b4bdab06a6e2cb06745bded34dd ]

The K3 PRUs are 32-bit processors and in general have some limitations
in using the standard ARMv8 memcpy function for loading firmware segments,
so the driver already uses a custom memcpy implementation. This added
logic however is limited to only IRAMs at the moment, but the loading
into Data RAMs is not completely ok either and does generate a kernel
crash for unaligned accesses.

Fix these crashes by removing the existing IRAM logic limitation and
extending the custom memcpy usage to Data RAMs as well for all K3 SoCs.

Fixes: 1d39f4d19921 ("remoteproc: pru: Add support for various PRU cores on K3 AM65x SoCs")
Signed-off-by: Suman Anna <s-anna@ti.com>
Link: https://lore.kernel.org/r/20210315205859.19590-1-s-anna@ti.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/pru_rproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
index 2667919d76b3..16979c1cd2f4 100644
--- a/drivers/remoteproc/pru_rproc.c
+++ b/drivers/remoteproc/pru_rproc.c
@@ -585,7 +585,7 @@ pru_rproc_load_elf_segments(struct rproc *rproc, const struct firmware *fw)
 			break;
 		}
 
-		if (pru->data->is_k3 && is_iram) {
+		if (pru->data->is_k3) {
 			ret = pru_rproc_memcpy(ptr, elf_data + phdr->p_offset,
 					       filesz);
 			if (ret) {
-- 
2.30.2



