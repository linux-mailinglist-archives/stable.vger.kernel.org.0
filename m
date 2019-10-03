Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE0CCA974
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404377AbfJCQmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404062AbfJCQmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:42:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066A92054F;
        Thu,  3 Oct 2019 16:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120955;
        bh=iupxWFpcY6/cgaLlrAWuYCcnrImMYlOV5CQiGwgF2WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBuHG/FykYr7PhTKBry71DQslStZ69w8+4i0DAUO3kUYrZrpIbU9dDiRY335ymg1X
         EPgVQYKcbRuINLh6OloU7/6FyvU0PIQV2g47KHqTYoIri5G7N4B+H925vaEhzUMc9z
         D9TAdw/x9j8dBrCCuD5OlqgNw6mkTtItCdgaDKXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Quinlan <james.quinlan@broadcom.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 099/344] firmware: arm_scmi: Check if platform has released shmem before using
Date:   Thu,  3 Oct 2019 17:51:04 +0200
Message-Id: <20191003154549.966139872@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 9dc34d635c67e57051853855c43249408641a5ab ]

Sometimes platfom may take too long to respond to the command and OS
might timeout before platform transfer the ownership of the shared
memory region to the OS with the response.

Since the mailbox channel associated with the channel is freed and new
commands are dispatch on the same channel, OS needs to wait until it
gets back the ownership. If not, either OS may end up overwriting the
platform response for the last command(which is fine as OS timed out
that command) or platform might overwrite the payload for the next
command with the response for the old.

The latter is problematic as platform may end up interpretting the
response as the payload. In order to avoid such race, let's wait until
the OS gets back the ownership before we prepare the shared memory with
the payload for the next command.

Reported-by: Jim Quinlan <james.quinlan@broadcom.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index b5bc4c7a8fab2..b49c9e6f4bf10 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -271,6 +271,14 @@ static void scmi_tx_prepare(struct mbox_client *cl, void *m)
 	struct scmi_chan_info *cinfo = client_to_scmi_chan_info(cl);
 	struct scmi_shared_mem __iomem *mem = cinfo->payload;
 
+	/*
+	 * Ideally channel must be free by now unless OS timeout last
+	 * request and platform continued to process the same, wait
+	 * until it releases the shared memory, otherwise we may endup
+	 * overwriting its response with new message payload or vice-versa
+	 */
+	spin_until_cond(ioread32(&mem->channel_status) &
+			SCMI_SHMEM_CHAN_STAT_CHANNEL_FREE);
 	/* Mark channel busy + clear error */
 	iowrite32(0x0, &mem->channel_status);
 	iowrite32(t->hdr.poll_completion ? 0 : SCMI_SHMEM_FLAG_INTR_ENABLED,
-- 
2.20.1



