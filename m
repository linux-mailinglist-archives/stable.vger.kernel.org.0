Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C96431D53
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhJRNuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234015AbhJRNsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:48:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26E9C613D5;
        Mon, 18 Oct 2021 13:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564217;
        bh=8pbmoMm1XhlbrHMxJD1caV5O4QJWhfMAtEFJXtpu3+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ueg9CwjBtxT8hnjU++26TyjXYvmlu0jNRSFpaDhnFgv726Qs3PpJtTrI45O5xIp29
         jZm2RZRBlzU88nXP+EMgeKviGTlDCLxV1iHTVjtSj/vqGjnBE2Mqsn/AhwvQXwi4KU
         tXBuCglswimi4/J8RZ5kOXzZBisdWfQyJWpAvyrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 086/103] platform/mellanox: mlxreg-io: Fix read access of n-bytes size attributes
Date:   Mon, 18 Oct 2021 15:25:02 +0200
Message-Id: <20211018132337.642837502@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

commit db9cc7d6f95e7d89b0ce57e785cfd9d67a7505d8 upstream.

Fix shift argument for function rol32(). It should be provided in bits,
while was provided in bytes.

Fixes: 86148190a7db ("platform/mellanox: mlxreg-io: Add support for complex attributes")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20210927142214.2613929-3-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/mellanox/mlxreg-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/mellanox/mlxreg-io.c
+++ b/drivers/platform/mellanox/mlxreg-io.c
@@ -98,7 +98,7 @@ mlxreg_io_get_reg(void *regmap, struct m
 			if (ret)
 				goto access_error;
 
-			*regval |= rol32(val, regsize * i);
+			*regval |= rol32(val, regsize * i * 8);
 		}
 	}
 


