Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4162E12163E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbfLPS1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731095AbfLPSPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:15:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 983F6206E0;
        Mon, 16 Dec 2019 18:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520135;
        bh=GBpi+2jc9TM5PgxUcdAcZ9oSk3/lTAFmaEpX0O4ukaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JccahedrrOWP+wz+oOPkt3dmSA0ww0CT5mxly/9hMDoN2Ykg39sa+ctrc0Be5Kg7f
         xZGmQQxXUWjVjjkF338EbhvRTWx52TPOMkDVmGjE9aMQxxQKRS1c8z0Yli+uJQaLjP
         g5zn0RVYHEXK0NnQ2DQiuRrcOMDFPd2hV0McwblI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Brunberg <ingo_brunberg@web.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.4 003/177] nvme: Namepace identification descriptor list is optional
Date:   Mon, 16 Dec 2019 18:47:39 +0100
Message-Id: <20191216174811.740598147@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 22802bf742c25b1e2473c70b3b99da98af65ef4d upstream.

Despite NVM Express specification 1.3 requires a controller claiming to
be 1.3 or higher implement Identify CNS 03h (Namespace Identification
Descriptor list), the driver doesn't really need this identification in
order to use a namespace. The code had already documented in comments
that we're not to consider an error to this command.

Return success if the controller provided any response to an
namespace identification descriptors command.

Fixes: 538af88ea7d9de24 ("nvme: make nvme_report_ns_ids propagate error back")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=205679
Reported-by: Ingo Brunberg <ingo_brunberg@web.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: stable@vger.kernel.org # 5.4+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1727,6 +1727,8 @@ static int nvme_report_ns_ids(struct nvm
 		if (ret)
 			dev_warn(ctrl->device,
 				 "Identify Descriptors failed (%d)\n", ret);
+		if (ret > 0)
+			ret = 0;
 	}
 	return ret;
 }


