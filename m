Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318CF24BCF8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgHTM4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729114AbgHTJlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:41:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D1020724;
        Thu, 20 Aug 2020 09:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916514;
        bh=KGzPf/rdCRUwBSQBvzEttjBkAfBjvfkrfl5505s+/ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urh7Wwn9yX4CHYoe9w0EdM03pjaPGSagVeqTO2uwG8/gtcp3ILR6Vm0VVholJm0lo
         cjJnHHWKQuTeD5X1fXCN0QTdGltu3kOwspzjEayCTR53oiK0HHQ0dWTOflsjxaK3ma
         Gvt+iT9xLJuXjOReuF43CH/4AvcYo3ALMWzKyv0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Jane Chu <jane.chu@oracle.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 153/204] libnvdimm/security: fix a typo
Date:   Thu, 20 Aug 2020 11:20:50 +0200
Message-Id: <20200820091613.883056922@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jane Chu <jane.chu@oracle.com>

[ Upstream commit dad42d17558f316e9e807698cd4207359b636084 ]

commit d78c620a2e82 ("libnvdimm/security: Introduce a 'frozen' attribute")
introduced a typo, causing a 'nvdimm->sec.flags' update being overwritten
by the subsequent update meant for 'nvdimm->sec.ext_flags'.

Link: https://lore.kernel.org/r/1596494499-9852-1-git-send-email-jane.chu@oracle.com
Fixes: d78c620a2e82 ("libnvdimm/security: Introduce a 'frozen' attribute")
Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 89b85970912db..acfd211c01b9c 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -457,7 +457,7 @@ void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
 	clear_bit(NDD_WORK_PENDING, &nvdimm->flags);
 	put_device(&nvdimm->dev);
 	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
-	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
+	nvdimm->sec.ext_flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
 }
 
 void nvdimm_security_overwrite_query(struct work_struct *work)
-- 
2.25.1



