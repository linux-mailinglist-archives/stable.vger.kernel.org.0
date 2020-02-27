Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4597C171F78
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbgB0N5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:57:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732312AbgB0N5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:57:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74F4E2073D;
        Thu, 27 Feb 2020 13:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811857;
        bh=2+cmvOTfjefLg7z9K6NEbzvp0YsZpeIAhXSEBWBCpx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbQjEvgIkSqr/7UuLfcfW7mH7uMy+KOZeeVZ7KtUq2GlyJo51lD6RkQlGRwcKCrCF
         TWn1WZeV/eAhtPmySEoz34AZgRIJUuJDt7Y3NHlNGto1H2FvcO9ErpeegG11B1uz32
         P/E3zx6NqLwuiIIpHVnSUj0tijWWhaL60RuKuyKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 129/237] cmd64x: potential buffer overflow in cmd64x_program_timings()
Date:   Thu, 27 Feb 2020 14:35:43 +0100
Message-Id: <20200227132306.236241168@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 117fcc3053606d8db5cef8821dca15022ae578bb ]

The "drive->dn" value is a u8 and it is controlled by root only, but
it could be out of bounds here so let's check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ide/cmd64x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ide/cmd64x.c b/drivers/ide/cmd64x.c
index b127ed60c7336..9dde8390da09b 100644
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -65,6 +65,9 @@ static void cmd64x_program_timings(ide_drive_t *drive, u8 mode)
 	struct ide_timing t;
 	u8 arttim = 0;
 
+	if (drive->dn >= ARRAY_SIZE(drwtim_regs))
+		return;
+
 	ide_timing_compute(drive, mode, &t, T, 0);
 
 	/*
-- 
2.20.1



