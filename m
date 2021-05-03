Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6A9371DA0
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhECRBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 13:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234042AbhECQ5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE63861972;
        Mon,  3 May 2021 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060233;
        bh=hZvv2NqKUI4KZS94mjZPDWYNClj7uCjaJrTt6DLLZ4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBTTQpxAfZIo7LQSQsPNTaEfKiCdAr7eYwL9Ot2j+g31NkxI33LpcKxh1CnpApX7h
         uXIqEesu3Kxg2oBQlNhLQIlf/EQjmx7srUV7xODJ9VEPYwSJGHey1A/z3S25DpdOE1
         ny5LORriZoYoMxA8oWwpLzr7D/zsnBVQyCy/LOWvnPPSatw2HmISPIGLYONnrf+t9d
         R7sx0IXi5iNAxhrdOkcU1Vi3ZKO1HkC3OH9CDYoiBI8YYTnteFJyqEG1hjsuoe5N9K
         b3yyKHNd/0i/UsumQxI1GMoDi+bz6cljQUjXkDGV+DdnXUMa+L3grjUgFqbYjN70dv
         8hFQKU4CzncPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.4 16/16] scsi: libfc: Fix a format specifier
Date:   Mon,  3 May 2021 12:43:29 -0400
Message-Id: <20210503164329.2854739-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 90d6697810f06aceea9de71ad836a8c7669789cd ]

Since the 'mfs' member has been declared as 'u32' in include/scsi/libfc.h,
use the %u format specifier instead of %hu. This patch fixes the following
clang compiler warning:

warning: format specifies type
      'unsigned short' but the argument has type 'u32' (aka 'unsigned int')
      [-Wformat]
                             "lport->mfs:%hu\n", mfs, lport->mfs);
                                         ~~~          ^~~~~~~~~~
                                         %u

Link: https://lore.kernel.org/r/20210415220826.29438-8-bvanassche@acm.org
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 867fc036d6ef..815d224b9ff8 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1754,7 +1754,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	if (mfs < FC_SP_MIN_MAX_PAYLOAD || mfs > FC_SP_MAX_MAX_PAYLOAD) {
 		FC_LPORT_DBG(lport, "FLOGI bad mfs:%hu response, "
-			     "lport->mfs:%hu\n", mfs, lport->mfs);
+			     "lport->mfs:%u\n", mfs, lport->mfs);
 		fc_lport_error(lport, fp);
 		goto out;
 	}
-- 
2.30.2

