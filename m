Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9208CD801
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfJFRzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730214AbfJFRfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:35:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF9662087E;
        Sun,  6 Oct 2019 17:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383354;
        bh=2n/Df1WVmgoy0vgbYlwsWecg+mwB5LQ52yY6MOGpQcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lK/CUGbyXPhlULOEyC1W/HWC8tXfnDXsXQG1aap79Ko8j31MajkSm6/+mmsUQKg3o
         Wamh+3iX4H8uqsrQ0NmJTHUUAxdivr3ko6OLXKbt0KdAc2JYRKGTonYYc5Jy7FTQUB
         5FJxDvWEYiJIt5nOz+AUeFGDmkei5jNVgcbPHXs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Jeff Layton <jlayton@kernel.org>, anton@enomsg.org,
        ccross@android.com, tony.luck@intel.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 072/137] pstore: fs superblock limits
Date:   Sun,  6 Oct 2019 19:20:56 +0200
Message-Id: <20191006171215.116163269@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepa Dinamani <deepa.kernel@gmail.com>

[ Upstream commit 83b8a3fbe3aa82ac3c253b698ae6a9be2dbdd5e0 ]

Leaving granularity at 1ns because it is dependent on the specific
attached backing pstore module. ramoops has microsecond resolution.

Fix the readback of ramoops fractional timestamp microseconds,
which has incorrectly been reporting the value as nanoseconds.

Fixes: 3f8f80f0cfeb ("pstore/ram: Read and write to the 'compressed' flag of pstore").

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Jeff Layton <jlayton@kernel.org>
Cc: anton@enomsg.org
Cc: ccross@android.com
Cc: keescook@chromium.org
Cc: tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 5b77098944151..db9f67d34af37 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -144,6 +144,7 @@ static int ramoops_read_kmsg_hdr(char *buffer, struct timespec64 *time,
 	if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lld.%lu-%c\n%n",
 		   (time64_t *)&time->tv_sec, &time->tv_nsec, &data_type,
 		   &header_length) == 3) {
+		time->tv_nsec *= 1000;
 		if (data_type == 'C')
 			*compressed = true;
 		else
@@ -151,6 +152,7 @@ static int ramoops_read_kmsg_hdr(char *buffer, struct timespec64 *time,
 	} else if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lld.%lu\n%n",
 			  (time64_t *)&time->tv_sec, &time->tv_nsec,
 			  &header_length) == 2) {
+		time->tv_nsec *= 1000;
 		*compressed = false;
 	} else {
 		time->tv_sec = 0;
-- 
2.20.1



