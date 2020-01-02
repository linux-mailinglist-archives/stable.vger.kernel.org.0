Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F5A12ED1C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgABWZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbgABWY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:24:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FDC820866;
        Thu,  2 Jan 2020 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003899;
        bh=xr71axG7fP6rNJ4rTQI9mf+5CR7DcYp/gTj+bO2IvyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExF6wlPT/7racJBPx7Cv8igiO60MJv/9KPisToCAAlO6aYbpjAfKecwAJv5L47pML
         jna0zQJimrz+W2qMoJ9PyAU3cZ1AI7JCYV9r7DL/GwsrFwz6k3u26HVBQfu6LLS81S
         Sh6KrmTi+59dPu9I7lZ6Nt4KW0HJuQdiG/Qf5cII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/91] powerpc/pseries/cmm: Implement release() function for sysfs device
Date:   Thu,  2 Jan 2020 23:07:10 +0100
Message-Id: <20200102220429.373947751@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 7d8212747435c534c8d564fbef4541a463c976ff ]

When unloading the module, one gets
  ------------[ cut here ]------------
  Device 'cmm0' does not have a release() function, it is broken and must be fixed. See Documentation/kobject.txt.
  WARNING: CPU: 0 PID: 19308 at drivers/base/core.c:1244 .device_release+0xcc/0xf0
  ...

We only have one static fake device. There is nothing to do when
releasing the device (via cmm_exit()).

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191031142933.10779-2-david@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/cmm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 4ac419c7eb4c..25224c9e1dc0 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -425,6 +425,10 @@ static struct bus_type cmm_subsys = {
 	.dev_name = "cmm",
 };
 
+static void cmm_release_device(struct device *dev)
+{
+}
+
 /**
  * cmm_sysfs_register - Register with sysfs
  *
@@ -440,6 +444,7 @@ static int cmm_sysfs_register(struct device *dev)
 
 	dev->id = 0;
 	dev->bus = &cmm_subsys;
+	dev->release = cmm_release_device;
 
 	if ((rc = device_register(dev)))
 		goto subsys_unregister;
-- 
2.20.1



