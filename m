Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C6A24B44F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgHTKDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730493AbgHTKB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:01:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05D3A22BF5;
        Thu, 20 Aug 2020 10:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917715;
        bh=Oxz/pHHOfZu6DDktw0jpD77BvgosJPVmTpZamkfr8Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCLsxO6g+PYYs7DORHgHU04yNGehqyFYwI8WSWO3aGAdtIYBlBlFsbBKqkWu1ZT/F
         2q8DJwnY+UZSYisefhXJJfeheV8Zay8TBSvSi4O90Qk3JqjFapLaG0TZk9JLakF9HF
         C5tNyhzMXf44NyB/t38PbxT2NAcHk3ocfeya/pDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bjorn@helgaas.com>,
        Bolarinwa Olayemi Saheed <refactormyself@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 101/212] iwlegacy: Check the return value of pcie_capability_read_*()
Date:   Thu, 20 Aug 2020 11:21:14 +0200
Message-Id: <20200820091607.446726802@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>

[ Upstream commit 9018fd7f2a73e9b290f48a56b421558fa31e8b75 ]

On failure pcie_capability_read_dword() sets it's last parameter, val
to 0. However, with Patch 14/14, it is possible that val is set to ~0 on
failure. This would introduce a bug because (x & x) == (~0 & x).

This bug can be avoided without changing the function's behaviour if the
return value of pcie_capability_read_dword is checked to confirm success.

Check the return value of pcie_capability_read_dword() to ensure success.

Suggested-by: Bjorn Helgaas <bjorn@helgaas.com>
Signed-off-by: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200713175529.29715-3-refactormyself@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index db2373fe8ac32..55573d090503b 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -4302,8 +4302,8 @@ il_apm_init(struct il_priv *il)
 	 *    power savings, even without L1.
 	 */
 	if (il->cfg->set_l0s) {
-		pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
-		if (lctl & PCI_EXP_LNKCTL_ASPM_L1) {
+		ret = pcie_capability_read_word(il->pci_dev, PCI_EXP_LNKCTL, &lctl);
+		if (!ret && (lctl & PCI_EXP_LNKCTL_ASPM_L1)) {
 			/* L1-ASPM enabled; disable(!) L0S  */
 			il_set_bit(il, CSR_GIO_REG,
 				   CSR_GIO_REG_VAL_L0S_ENABLED);
-- 
2.25.1



