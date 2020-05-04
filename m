Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED0D1C4354
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbgEDRyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:54:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21719 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728158AbgEDRyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 13:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588614860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CjIIS1m4iAVPSDxzJVwEDqZnulFbyKq6kX/pTDDnEa0=;
        b=cy+NUQFf8uUooiv9EuoQTaXpTzjF7A7e2lXTGlec6RPT2/JMH2uuWQvbIrsb4HKXx4ZWte
        nQB/dN6CmxzeU1vOKEUQklI0eDKpRLsdukmeh1V5OsOwq9vOEve38HNOccwBJa6byydyXf
        MXBlQgHuOlMS2HJg3nOHwds6B1Tp+fM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-HkLQWVgeNZKg-G3tKppgzg-1; Mon, 04 May 2020 13:54:18 -0400
X-MC-Unique: HkLQWVgeNZKg-G3tKppgzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 827021005510;
        Mon,  4 May 2020 17:54:17 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C65725D9D3;
        Mon,  4 May 2020 17:54:16 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     stable@vger.kernel.org, njavali@marvell.com,
        himanshu.madhani@oracle.com
Subject: [PATCH] scsi: qla2xxx: Do not log message when reading port speed via sysfs
Date:   Mon,  4 May 2020 13:54:16 -0400
Message-Id: <20200504175416.15417-1-emilne@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Calling ql_log() inside qla2x00_port_speed_show() is causing messages
to be output to the console for no particularly good reason.  The sysfs
read routine should just return the information to userspace.  The only
reason to log a message is when the port speed actually changes, and
this already occurs elsewhere.

Cc: <stable@vger.kernel.org> # v5.1+
Fixes: 4910b524ac9 ("scsi: qla2xxx: Add support for setting port speed")
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
index 3325596..2c9e5ac 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1850,9 +1850,6 @@ qla2x00_port_speed_show(struct device *dev, struct =
device_attribute *attr,
 		return -EINVAL;
 	}
=20
-	ql_log(ql_log_info, vha, 0x70d6,
-	    "port speed:%d\n", ha->link_data_rate);
-
 	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha->link_data_rate]);
 }
=20
--=20
2.1.0

