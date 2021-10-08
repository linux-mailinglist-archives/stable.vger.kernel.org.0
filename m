Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A181D42698A
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbhJHLjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242663AbhJHLgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:36:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1216060FA0;
        Fri,  8 Oct 2021 11:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692734;
        bh=W978VNnoBPO6sW63/1v4s7wCVz59IicxzMl2SC1THb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnFEG2NoC3vFRNC7OqbBmosCXBhmX8TziNIq3VBgnDobwPlBElk7QR8Wl/k32vUS7
         tC8KsWyjdGfn/AWeXwfoI29YfWRDeUc4O2+82MTkMlcIF+oUtI/IJG++rPaTldbpmp
         IU43tDkmwu28rLN7IpSDzSi0T4EuNvQV7nkOwzOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 20/48] habanalabs: fail collective wait when not supported
Date:   Fri,  8 Oct 2021 13:27:56 +0200
Message-Id: <20211008112720.693141759@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit d09ff62c820b5950ab9958e77620a8498efe9386 ]

As collective wait operation is required only when NIC ports are
available, we disable the option to submit a CS in case all the ports
are disabled, which is the current situation in the upstream driver.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/command_submission.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/misc/habanalabs/common/command_submission.c b/drivers/misc/habanalabs/common/command_submission.c
index 80c60fb41bbc..d249101106de 100644
--- a/drivers/misc/habanalabs/common/command_submission.c
+++ b/drivers/misc/habanalabs/common/command_submission.c
@@ -1727,6 +1727,15 @@ static int cs_ioctl_signal_wait(struct hl_fpriv *hpriv, enum hl_cs_type cs_type,
 			goto free_cs_chunk_array;
 		}
 
+		if (!hdev->nic_ports_mask) {
+			atomic64_inc(&ctx->cs_counters.validation_drop_cnt);
+			atomic64_inc(&cntr->validation_drop_cnt);
+			dev_err(hdev->dev,
+				"Collective operations not supported when NIC ports are disabled");
+			rc = -EINVAL;
+			goto free_cs_chunk_array;
+		}
+
 		collective_engine_id = chunk->collective_engine_id;
 	}
 
-- 
2.33.0



