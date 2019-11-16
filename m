Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A2AFF057
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbfKPPva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729221AbfKPPv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:29 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8B8421887;
        Sat, 16 Nov 2019 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919489;
        bh=X0X+XnxcakSoGSTsODunSWW+0yo6QkYP+ksjJxsWRis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFLp6j65zTwOwA7rCg+BjyHv7eEJFHUp40QoD1UcNybJJ8J6pmupaaMVoOX0PQNJE
         eSh37F47uoNTgBYZlH3yMBHuFAENwQ+NCAq0Tv4CtaQeyd3+UoXD2Q4Hh8Py1Zgo2V
         bwVE/a2Eu4oXsgKS8I5E34f34mer2ic6bPGODaUs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 20/99] scsi: iscsi_tcp: Explicitly cast param in iscsi_sw_tcp_host_get_param
Date:   Sat, 16 Nov 2019 10:49:43 -0500
Message-Id: <20191116155103.10971-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 20054597f169090109fc3f0dfa1a48583f4178a4 ]

Clang warns when one enumerated type is implicitly converted to another.

drivers/scsi/iscsi_tcp.c:803:15: warning: implicit conversion from
enumeration type 'enum iscsi_host_param' to different enumeration type
'enum iscsi_param' [-Wenum-conversion]
                                                 &addr, param, buf);
                                                        ^~~~~
1 warning generated.

iscsi_conn_get_addr_param handles ISCSI_HOST_PARAM_IPADDRESS just fine
so add an explicit cast to iscsi_param to make it clear to Clang that
this is expected behavior.

Link: https://github.com/ClangBuiltLinux/linux/issues/153
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ace4f1f41b8e0..d60564397be54 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -798,7 +798,8 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 			return rc;
 
 		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
-						 &addr, param, buf);
+						 &addr,
+						 (enum iscsi_param)param, buf);
 	default:
 		return iscsi_host_get_param(shost, param, buf);
 	}
-- 
2.20.1

