Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327F437CC9A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244409AbhELQpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239136AbhELQjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:39:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EBDB61CE1;
        Wed, 12 May 2021 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835403;
        bh=N/nLMR2/oSpnPg+n0eQZZkSoforD+QIsgdjsbkqmyuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hd9fIYHiPaAsjQ6LmDn3hhgiE4NdChwuFKEn1bLn73dhtS7/cWZngOTgruPZ6crZ/
         8lAr2sGeJKVbTra+4lhKfMyr6pY94Rfd8RXNXY93BkWl+bPfFZrEabhBm3/frbmb4U
         yWqV/fPTjq4tXrSkL0pEzQCtBXDgY+UAK01cnw5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 329/677] hwmon: (pmbus/pxe1610) dont bail out when not all pages are active
Date:   Wed, 12 May 2021 16:46:15 +0200
Message-Id: <20210512144848.189477610@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Fertser <fercerpav@gmail.com>

[ Upstream commit f025314306ae17a3fdaf2874d7e878ce19cea363 ]

Certain VRs might be configured to use only the first output channel and
so the mode for the second will be 0. Handle this gracefully.

Fixes: b9fa0a3acfd8 ("hwmon: (pmbus/core) Add support for vid mode detection per page bases")
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Link: https://lore.kernel.org/r/20210416102926.13614-1-fercerpav@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pxe1610.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/pmbus/pxe1610.c b/drivers/hwmon/pmbus/pxe1610.c
index da27ce34ee3f..eb4a06003b7f 100644
--- a/drivers/hwmon/pmbus/pxe1610.c
+++ b/drivers/hwmon/pmbus/pxe1610.c
@@ -41,6 +41,15 @@ static int pxe1610_identify(struct i2c_client *client,
 				info->vrm_version[i] = vr13;
 				break;
 			default:
+				/*
+				 * If prior pages are available limit operation
+				 * to them
+				 */
+				if (i != 0) {
+					info->pages = i;
+					return 0;
+				}
+
 				return -ENODEV;
 			}
 		}
-- 
2.30.2



