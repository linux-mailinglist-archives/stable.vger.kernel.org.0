Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8F048925F
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbiAJHmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241810AbiAJHjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:39:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3536C02549D;
        Sun,  9 Jan 2022 23:33:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B154B81216;
        Mon, 10 Jan 2022 07:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CD8C36AED;
        Mon, 10 Jan 2022 07:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800026;
        bh=zw1NdbOtkyijo7fXN+XvLZTKIYt/6pYw8B0XdMToLBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hy01yk+N8eZJNkZyRtZ3YTqamMFVT/5EcNfKOiBIgYyMbTR1kGbytAX4E8+0SIP5k
         lyfLR0Kcmlbcdh9+l4x9zl6kk9FJs7R5/LIZU5Dl8GqspVEnzzr9pxLyMMpge2g26q
         6sRlbQJaMuOgZxqvw5AMGGGXpypPJ0NTzsO10JdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luiz Sampaio <sampaio.ime@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 53/72] auxdisplay: charlcd: checking for pointer reference before dereferencing
Date:   Mon, 10 Jan 2022 08:23:30 +0100
Message-Id: <20220110071823.336401449@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Sampaio <sampaio.ime@gmail.com>

[ Upstream commit 4daa9ff89ef27be43c15995412d6aee393a78200 ]

Check if the pointer lcd->ops->init_display exists before dereferencing it.
If a driver called charlcd_init() without defining the ops, this would
return segmentation fault, as happened to me when implementing a charlcd
driver.  Checking the pointer before dereferencing protects from
segmentation fault.

Signed-off-by: Luiz Sampaio <sampaio.ime@gmail.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/charlcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index 304accde365c8..6c010d4efa4ae 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -578,6 +578,9 @@ static int charlcd_init(struct charlcd *lcd)
 	 * Since charlcd_init_display() needs to write data, we have to
 	 * enable mark the LCD initialized just before.
 	 */
+	if (WARN_ON(!lcd->ops->init_display))
+		return -EINVAL;
+
 	ret = lcd->ops->init_display(lcd);
 	if (ret)
 		return ret;
-- 
2.34.1



