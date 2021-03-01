Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BAF3289D7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239191AbhCASGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239237AbhCAR7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:59:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F0F64F11;
        Mon,  1 Mar 2021 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620933;
        bh=0VApcNbJO8KNfMiuGi0jfvrbmadcMglLwh2nJAtV798=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaEi1Ja1Jdy5afYQQPD0UcZjKmXQS/F35wfmvk188gQIdUhRPE+kaOZMETeKZ9J/M
         uIqe3QauV0y66PWTzpvlQeeShEq0cvH7ElfAie12EATMS2M2fttww4RhoLiCsPJAdC
         URE0GpLSdF9fXbumaiwCiyhm85nTvVC5rz/Nx5R4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Roy Im <Roy.Im.Opensource@diasemi.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 302/775] Input: da7280 - fix missing error test
Date:   Mon,  1 Mar 2021 17:07:50 +0100
Message-Id: <20210301161216.546224228@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 1e2020aa0da00051d94c4690c023c45d8f3834bd ]

An "if" testing for error condition has accidentally been dropped from
the code.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: cd3f609823a5 ("Input: new da7280 haptic driver")
Reviewed-by: Roy Im <Roy.Im.Opensource@diasemi.com>
Link: https://lore.kernel.org/r/X9j8lGFgijzHyYZZ@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/da7280.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/misc/da7280.c b/drivers/input/misc/da7280.c
index 37568b00873d4..2f698a8c1d650 100644
--- a/drivers/input/misc/da7280.c
+++ b/drivers/input/misc/da7280.c
@@ -863,6 +863,7 @@ static void da7280_parse_properties(struct device *dev,
 		gpi_str3[7] = '0' + i;
 		haptics->gpi_ctl[i].polarity = 0;
 		error = device_property_read_string(dev, gpi_str3, &str);
+		if (!error)
 			haptics->gpi_ctl[i].polarity =
 				da7280_haptic_of_gpi_pol_str(dev, str);
 	}
-- 
2.27.0



