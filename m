Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7093F9417
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 07:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244278AbhH0Feq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 01:34:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33245 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244276AbhH0Fep (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 01:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630042436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nDJoWCqAn7xRSrZI8YAG5NUXcyahKOzT6a0Q77ySVoA=;
        b=EYr1eMWCeXs+8QthFwLD0tW+cfBkVqv/qQFAq+R0GKeWhha0N7f5Hl3zkGll8rtUCNT/oC
        5yFZKvfG+47B5+YI3SauU/rN1+H7HNxAsuKMiHfqlN9wTZCZOY7LIohDo5/kpFKv9rKaoh
        MXsnSaTYMPCOQwlfSqNUNzL6w1Hfako=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-yamMueV4Nu2FNyxigaUoxg-1; Fri, 27 Aug 2021 01:33:55 -0400
X-MC-Unique: yamMueV4Nu2FNyxigaUoxg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59745344AF;
        Fri, 27 Aug 2021 05:33:54 +0000 (UTC)
Received: from fedora-t480.redhat.com (unknown [10.39.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C975160C04;
        Fri, 27 Aug 2021 05:33:49 +0000 (UTC)
From:   Kate Hsuan <hpa@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Hans de Goede <hdegoede@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Kate Hsuan <hpa@redhat.com>
Subject: [PATCH v2 0/1] libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs
Date:   Fri, 27 Aug 2021 01:33:43 -0400
Message-Id: <20210827053344.15087-1-hpa@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Entire disabling NCQ for Samsugn 860/870 SSD will cause I/O performance
drop. In this case, a flag ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL is
introduced to used to performe additional check for these SSDs. If it
finds it's parent ATA controller is AsMedia/AMD/Marvell, the NCQ will be
disabled. Otherwise, the NCQ is kept to enable.

Kate Hsuan (1):
  libata: libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870
    SSDs

 drivers/ata/libata-core.c | 37 ++++++++++++++++++++++++++++++++-----
 include/linux/libata.h    |  3 +++
 2 files changed, 35 insertions(+), 5 deletions(-)

-- 
2.31.1

