Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C072137DCB
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgAKKB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgAKKB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:01:28 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B076E2077C;
        Sat, 11 Jan 2020 10:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736888;
        bh=bDANlImqzOWC7Mbdrh57R0b9pLFSzdomDK9sy7LxT8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvCiahLWOOZMH/i3jHNmNfmY5zZkgIYaOy4PobFf89OiEWDLNt5H3fVItrUUr6JG+
         V3eA1HI+BZds0roNr1zhhE3HK8bzFZ2sWvgMmx5WAFZDP1CQGhP69wK6oDhh6VLlus
         AvHYkket+Q2o1W3ayGW39V4t5y+rqNEqYoQ6/hBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.9 42/91] media: usb: fix memory leak in af9005_identify_state
Date:   Sat, 11 Jan 2020 10:49:35 +0100
Message-Id: <20200111094900.993167576@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 2289adbfa559050d2a38bcd9caac1c18b800e928 upstream.

In af9005_identify_state when returning -EIO the allocated buffer should
be released. Replace the "return -EIO" with assignment into ret and move
deb_info() under a check.

Fixes: af4e067e1dcf ("V4L/DVB (5625): Add support for the AF9005 demodulator from Afatech")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/af9005.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/dvb-usb/af9005.c
+++ b/drivers/media/usb/dvb-usb/af9005.c
@@ -990,8 +990,9 @@ static int af9005_identify_state(struct
 	else if (reply == 0x02)
 		*cold = 0;
 	else
-		return -EIO;
-	deb_info("Identify state cold = %d\n", *cold);
+		ret = -EIO;
+	if (!ret)
+		deb_info("Identify state cold = %d\n", *cold);
 
 err:
 	kfree(buf);


