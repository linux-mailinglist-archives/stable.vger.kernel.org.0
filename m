Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56BDFF196
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbfKPPsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:48:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbfKPPsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:48:02 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14D7D20815;
        Sat, 16 Nov 2019 15:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919281;
        bh=M8yWhEhiTwNnh56fDzs9IjxrNHd3LnDK6hpxY8eNykY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03/AV6rId3P1g1Omt+Vpv/Sq5XusEuPASaeByd2Zq4Qs9J80J63znMllXkx1W+bnv
         NoPtBCog8378DRFq6ZLz07vxFM1EL+kAURjF8fBIwfFbfRzePLDW0BLNbsR3/zx8/m
         tRb4fv8QrdOkl/dcCSC6K9uMrb6CqVM3q5awUr4w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 033/150] scsi: iscsi_tcp: Explicitly cast param in iscsi_sw_tcp_host_get_param
Date:   Sat, 16 Nov 2019 10:45:31 -0500
Message-Id: <20191116154729.9573-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
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
index e11eff6b0e97d..045207b5560eb 100644
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

