Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE2246F4C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388783AbgHQRpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388788AbgHQQO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:14:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2F462245C;
        Mon, 17 Aug 2020 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680867;
        bh=aHaqBn9NaqRET30HN6EPuCkfoeexiVbUPTNMAv09oUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTG8xst31lpRl5EH0hHslMk87LhyVHZMhaBCiNTLbxduj11mr2YFOUWIu3p5L6QZK
         Jv9TowHqnoQr+DlFJ70CyzIFCZCj5gvnxmay/4oVyCEPvDvr5Tww+waPOMo3DPTKFZ
         MTVUccSwU4P48cNwlqWdWYuqWlCuCup51jEacGNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/168] PCI/ASPM: Add missing newline in sysfs policy
Date:   Mon, 17 Aug 2020 17:17:00 +0200
Message-Id: <20200817143738.166408739@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 3167e3d340c092fd47924bc4d23117a3074ef9a9 ]

When I cat ASPM parameter 'policy' by sysfs, it displays as follows.  Add a
newline for easy reading.  Other sysfs attributes already include a
newline.

  [root@localhost ~]# cat /sys/module/pcie_aspm/parameters/policy
  [default] performance powersave powersupersave [root@localhost ~]#

Fixes: 7d715a6c1ae5 ("PCI: add PCI Express ASPM support")
Link: https://lore.kernel.org/r/1594972765-10404-1-git-send-email-wangxiongfeng2@huawei.com
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 6e50f84733b75..279f9f0197b01 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1164,6 +1164,7 @@ static int pcie_aspm_get_policy(char *buffer, const struct kernel_param *kp)
 			cnt += sprintf(buffer + cnt, "[%s] ", policy_str[i]);
 		else
 			cnt += sprintf(buffer + cnt, "%s ", policy_str[i]);
+	cnt += sprintf(buffer + cnt, "\n");
 	return cnt;
 }
 
-- 
2.25.1



