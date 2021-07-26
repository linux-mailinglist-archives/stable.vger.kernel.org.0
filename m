Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B487B3D607F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbhGZPWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237388AbhGZPWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76A6C60EB2;
        Mon, 26 Jul 2021 16:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315385;
        bh=cgH073LWw0eTXV3+ESWoNu9JY4+Ou+SLK4vjGfJL7Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiHGRpg/15RtFtDz0axidbs+qCfTqBwvfe0WwySKakh1s0SVS5ORQPTVuooI4tky7
         NtaLtqpwZFxqazly77hSwmxdGBzKgxgF9fPeMoK+ix6aTjjPbJflHS9E16DepKIG+R
         XgBsJo3XbqWmtzc+VgxVl6crKmma8eKdlyg9eNmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/167] efi/tpm: Differentiate missing and invalid final event log table.
Date:   Mon, 26 Jul 2021 17:38:21 +0200
Message-Id: <20210726153841.669851162@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 674a9f1f6815849bfb5bf385e7da8fc198aaaba9 ]

Missing TPM final event log table is not a firmware bug.

Clearly if providing event log in the old format makes the final event
log invalid it should not be provided at least in that case.

Fixes: b4f1874c6216 ("tpm: check event log version before reading final events")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/tpm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index c1955d320fec..8f665678e9e3 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -62,9 +62,11 @@ int __init efi_tpm_eventlog_init(void)
 	tbl_size = sizeof(*log_tbl) + log_tbl->size;
 	memblock_reserve(efi.tpm_log, tbl_size);
 
-	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR ||
-	    log_tbl->version != EFI_TCG2_EVENT_LOG_FORMAT_TCG_2) {
-		pr_warn(FW_BUG "TPM Final Events table missing or invalid\n");
+	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR) {
+		pr_info("TPM Final Events table not present\n");
+		goto out;
+	} else if (log_tbl->version != EFI_TCG2_EVENT_LOG_FORMAT_TCG_2) {
+		pr_warn(FW_BUG "TPM Final Events table invalid\n");
 		goto out;
 	}
 
-- 
2.30.2



