Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BAF4290D5
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbhJKOM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240189AbhJKOK4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:10:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3352761267;
        Mon, 11 Oct 2021 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960967;
        bh=NskSf+BSt/Y1SO1wRRawuj99H0wD8RiaRoYVTGR771w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmdSc9pAscVdznxdmRzRqnqXGt78OA0RnlbJXK5Rkdq6tPEmOLWjJRMIaBF/C7B5z
         riR2SI6WntreKN0yGwL0vMxEBeY+Z4H6z+SD6BMf7X08KEiSQfjcs7MzGO7OR89JYX
         GSbGT5gSxFqZ6kM0noojpFue34F3LzF2oncMR31o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 127/151] i2c: mlxcpld: Fix criteria for frequency setting
Date:   Mon, 11 Oct 2021 15:46:39 +0200
Message-Id: <20211011134521.914247484@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit 52f57396c75acd77ebcdf3d20aed24ed248e9f79 ]

Value for getting frequency capability wrongly has been taken from
register offset instead of register value.

Fixes: 66b0c2846ba8 ("i2c: mlxcpld: Add support for I2C bus frequency setting")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxcpld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mlxcpld.c b/drivers/i2c/busses/i2c-mlxcpld.c
index 4e0b7c2882ce..6d41c3db8a2b 100644
--- a/drivers/i2c/busses/i2c-mlxcpld.c
+++ b/drivers/i2c/busses/i2c-mlxcpld.c
@@ -495,7 +495,7 @@ mlxcpld_i2c_set_frequency(struct mlxcpld_i2c_priv *priv,
 		return err;
 
 	/* Set frequency only if it is not 100KHz, which is default. */
-	switch ((data->reg & data->mask) >> data->bit) {
+	switch ((regval & data->mask) >> data->bit) {
 	case MLXCPLD_I2C_FREQ_1000KHZ:
 		freq = MLXCPLD_I2C_FREQ_1000KHZ_SET;
 		break;
-- 
2.33.0



