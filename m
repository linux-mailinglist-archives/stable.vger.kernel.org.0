Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97E8442DCE
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 13:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhKBM2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 08:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBM2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 08:28:19 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 Nov 2021 05:25:44 PDT
Received: from lb2-smtp-cloud8.xs4all.net (lb2-smtp-cloud8.xs4all.net [IPv6:2001:888:0:108::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B70C061714
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 05:25:44 -0700 (PDT)
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id hsq3mJkibDjkdhsqAmFmMk; Tue, 02 Nov 2021 13:24:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1635855874; bh=bp/8lnWcqn7N40vfwj9NNYeek29lTgdB1Uv9KM6bcig=;
        h=From:To:Subject:Date:Message-Id:MIME-Version:From:Subject;
        b=db0hEj8XsH8pwRISgPZOth/bV0Jr5ADNt4rjBTnmeHdrzKn1GbhBe3GedQQBH352y
         /tDFhf4mj0+vopsZJ1liJlXcEWZ8Ibi2NKCi9j9/m8HlierjWZnxdQvSAhumr/x7Yq
         DEaZ0xScs8exMyErSAahMt/h1n0HkiT0Q77Pt1KenJODFBDLE0z/DN0yzxHo21RsZi
         q4cQF4A3WL0qsTROZHfx2gC5Ggk1axNCkFx14LEEpSpgbBu0kqSHDFOgrMEaj7vM7e
         /LdHK9rxaj2jH/ePLlCyVGGJE3OoYZ2klJ7qvBlX4YNI82XtAthCHfIwf5AoOJtLIT
         IZ2gMsSqfLI3g==
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Subject: [PATCH 1/2] cec: copy sequence field for the reply
Date:   Tue,  2 Nov 2021 13:24:26 +0100
Message-Id: <20211102122427.544085-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfOYCBZHaH4E4XcLMv6DiZ1sNEcIFoI+sia2XHbnxZXYMuv6PCACWO3yh3o5clAOrSrez3M8RW9H7lBvQ+GraxuIDHh/fDcT2M0vmBpRyD5lLlMPMJuHg
 hXXhaZTB+vbHzoyb1fF559D5dEPaSSNWSR+Dts2r6HPOtwSU4Z2yM0JXeKh/xPNQ7Z/uok2H0HkV/kGhgCXXGLIybSrnC/hxki26n4mf57jpcANhAwpuNS1w
 Binrc3aOUOqpbGh+wLtffhdR9M9sKFMzW87rMNWeVAYIh8/8B6gMrfOGCMaOAgRL0Wegf9LaL/i4WPnVisCRHi8bbCz/8d3AUJktuDVo5IY=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the reply for a non-blocking transmit arrives, the sequence
field for that reply was never filled in, so userspace would have no
way of associating the reply to the original transmit.

Copy the sequence field to ensure that this is now possible.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 0dbacebede1e ([media] cec: move the CEC framework out of staging and to media)
Cc: <stable@vger.kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 79fa36de8a04..cd9cb354dc2c 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1199,6 +1199,7 @@ void cec_received_msg_ts(struct cec_adapter *adap,
 			if (abort)
 				dst->rx_status |= CEC_RX_STATUS_FEATURE_ABORT;
 			msg->flags = dst->flags;
+			msg->sequence = dst->sequence;
 			/* Remove it from the wait_queue */
 			list_del_init(&data->list);
 
-- 
2.33.0

