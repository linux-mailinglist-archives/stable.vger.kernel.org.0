Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C3E126960
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfLSShE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbfLSShD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:37:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7150224679;
        Thu, 19 Dec 2019 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780622;
        bh=NzS+thb2zRhKzX02D+ejkXOi1iRJq/6D5XAXZ6VOCSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaTOLYfwguwpzyO23FfEYcB8NNVow5JVjcP9hz1sin1TjVNfsUTM4F9gqYivVi/ao
         KWWALJxqdaI7aQlnT2LFHs1giFGasB+l3eOq7D+TbXmWbnxcF6aHdAVxuxHJj3roGV
         MEHwXR4pSQ5HivGXOMgm6s0cIhDSaYB2g5RBb640=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 049/162] MIPS: OCTEON: cvmx_pko_mem_debug8: use oldest forward compatible definition
Date:   Thu, 19 Dec 2019 19:32:37 +0100
Message-Id: <20191219183210.878655332@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 1c6121c39677175bd372076020948e184bad4b6b ]

cn58xx is compatible with cn50xx, so use the latter.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
[paul.burton@mips.com: s/cn52xx/cn50xx/ in commit message.]
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c | 2 +-
 arch/mips/include/asm/octeon/cvmx-pko.h            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c b/arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c
index 8241fc6aa17d8..3839feba68f20 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-cmd-queue.c
@@ -266,7 +266,7 @@ int cvmx_cmd_queue_length(cvmx_cmd_queue_id_t queue_id)
 		} else {
 			union cvmx_pko_mem_debug8 debug8;
 			debug8.u64 = cvmx_read_csr(CVMX_PKO_MEM_DEBUG8);
-			return debug8.cn58xx.doorbell;
+			return debug8.cn50xx.doorbell;
 		}
 	case CVMX_CMD_QUEUE_ZIP:
 	case CVMX_CMD_QUEUE_DFA:
diff --git a/arch/mips/include/asm/octeon/cvmx-pko.h b/arch/mips/include/asm/octeon/cvmx-pko.h
index 5f47f76ed510a..20eb9c46a75ab 100644
--- a/arch/mips/include/asm/octeon/cvmx-pko.h
+++ b/arch/mips/include/asm/octeon/cvmx-pko.h
@@ -611,7 +611,7 @@ static inline void cvmx_pko_get_port_status(uint64_t port_num, uint64_t clear,
 		pko_reg_read_idx.s.index = cvmx_pko_get_base_queue(port_num);
 		cvmx_write_csr(CVMX_PKO_REG_READ_IDX, pko_reg_read_idx.u64);
 		debug8.u64 = cvmx_read_csr(CVMX_PKO_MEM_DEBUG8);
-		status->doorbell = debug8.cn58xx.doorbell;
+		status->doorbell = debug8.cn50xx.doorbell;
 	}
 }
 
-- 
2.20.1



