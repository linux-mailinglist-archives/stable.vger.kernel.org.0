Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD944418FC
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhKAJx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhKAJvD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DB996125F;
        Mon,  1 Nov 2021 09:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759138;
        bh=UU9Vv4WT0O3DZbumFuKm1xnDfeCZMnvFLgjQ0DcbUVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlEbtOOy2yc1C0mqNgZPxTvhbMAIOOGGL7s87mAvnQhmNmT6kuB0sdFItd3oSPoeE
         NxQB0Wk7snDmop/paPz+0A0WMN4viBRG8IXU6pE8WjQAP9boe7wHre0Wx8v+3ylHrb
         YA7IuPjF0wkQuJ2kKSR5i57Bb9NqBqwt3iTEsli8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 110/125] net: hns3: expand buffer len for some debugfs command
Date:   Mon,  1 Nov 2021 10:18:03 +0100
Message-Id: <20211101082553.905585529@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit c7a6e3978ea952efb107ecf511c095c3bbb2945f ]

The specified buffer length for three debugfs files fd_tcam, uc and tqp
is not enough for their maximum needs, so this patch fixes them.

Fixes: b5a0b70d77b9 ("net: hns3: refactor dump fd tcam of debugfs")
Fixes: 1556ea9120ff ("net: hns3: refactor dump mac list of debugfs")
Fixes: d96b0e59468d ("net: hns3: refactor dump reg of debugfs")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index ce2fc283fe5c..b22b8baec54c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -138,7 +138,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "uc",
 		.cmd = HNAE3_DBG_CMD_MAC_UC,
 		.dentry = HNS3_DBG_DENTRY_MAC,
-		.buf_len = HNS3_DBG_READ_LEN,
+		.buf_len = HNS3_DBG_READ_LEN_128KB,
 		.init = hns3_dbg_common_file_init,
 	},
 	{
@@ -257,7 +257,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "tqp",
 		.cmd = HNAE3_DBG_CMD_REG_TQP,
 		.dentry = HNS3_DBG_DENTRY_REG,
-		.buf_len = HNS3_DBG_READ_LEN,
+		.buf_len = HNS3_DBG_READ_LEN_128KB,
 		.init = hns3_dbg_common_file_init,
 	},
 	{
@@ -299,7 +299,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "fd_tcam",
 		.cmd = HNAE3_DBG_CMD_FD_TCAM,
 		.dentry = HNS3_DBG_DENTRY_FD,
-		.buf_len = HNS3_DBG_READ_LEN,
+		.buf_len = HNS3_DBG_READ_LEN_1MB,
 		.init = hns3_dbg_common_file_init,
 	},
 	{
-- 
2.33.0



