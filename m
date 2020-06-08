Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCF71F2D59
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgFIAcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbgFHXPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C65212CC;
        Mon,  8 Jun 2020 23:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658107;
        bh=AbPJ7FvzSzyub/OlkB3mvX9rkt+sl9CLgSM1XLr4RVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUKIzwYNaQAxemq0PAoBudmdYASUY//paojL7BCz/EkGoma/oJfI4tdEiNYLkUOkI
         Op68NHqDKc6a5mzgMv3MU/IGwrkRKJjhTQQf4YqV7GbFTus/olijWY+6LYtkxsJ0Sk
         jOXY9fIaEyrGlczuElxI0S0o+IQ4apu0IAl/TXpA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ewan D. Milne" <emilne@redhat.com>, Lee Duncan <lduncan@suse.com>,
        Laurence Oberman <loberman@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 147/606] scsi: qla2xxx: Do not log message when reading port speed via sysfs
Date:   Mon,  8 Jun 2020 19:04:32 -0400
Message-Id: <20200608231211.3363633-147-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

commit fb9024b0646939e59d8a0b6799b317070619795a upstream.

Calling ql_log() inside qla2x00_port_speed_show() is causing messages to be
output to the console for no particularly good reason.  The sysfs read
routine should just return the information to userspace.  The only reason
to log a message is when the port speed actually changes, and this already
occurs elsewhere.

Link: https://lore.kernel.org/r/20200504175416.15417-1-emilne@redhat.com
Fixes: 4910b524ac9e ("scsi: qla2xxx: Add support for setting port speed")
Cc: <stable@vger.kernel.org> # v5.1+
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 9556392652e3..e3c45edd0e18 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1777,9 +1777,6 @@ qla2x00_port_speed_show(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	}
 
-	ql_log(ql_log_info, vha, 0x70d6,
-	    "port speed:%d\n", ha->link_data_rate);
-
 	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha->link_data_rate]);
 }
 
-- 
2.25.1

