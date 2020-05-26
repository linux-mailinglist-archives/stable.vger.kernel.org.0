Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19F41E2C44
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404301AbgEZTNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404298AbgEZTNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:13:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F2B8208DB;
        Tue, 26 May 2020 19:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520412;
        bh=Py3+27fq+KilaCdz5w6bUQlZKu+dOEQXm4a/GCeSecM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwgU+lRtljrKTZxk/kM2skaYjVBEZZNMdTQPK3WwQ3x+G4feYMi7dZq3a5oLhjxJV
         LbdZC8uPkiE5IWZriES2pva5+WUK3wrzsz06C9BPuM3RUcHDHJBn68iXHDgervxCCI
         aqDsaBr4WlApyngY8bCBdfUMkr//VLr4Vbuh5huY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaojian Cao <xiaojian.cao@cn.alps.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 028/126] HID: alps: ALPS_1657 is too specific; use U1_UNICORN_LEGACY instead
Date:   Tue, 26 May 2020 20:52:45 +0200
Message-Id: <20200526183940.110886734@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit 185af3e775b693f773d9a4b5a8c3cda69fc8ca0f ]

HID_DEVICE_ID_ALPS_1657 PID is too specific, as there are many other
ALPS hardware IDs using this particular touchpad.

Rename the identifier to HID_DEVICE_ID_ALPS_U1_UNICORN_LEGACY in order
to describe reality better.

Fixes: 640e403b1fd24 ("HID: alps: Add AUI1657 device ID")
Reported-by: Xiaojian Cao <xiaojian.cao@cn.alps.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 2 +-
 drivers/hid/hid-ids.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index c2a2bd528890..b2ad319a74b9 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -802,7 +802,7 @@ static int alps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		break;
 	case HID_DEVICE_ID_ALPS_U1_DUAL:
 	case HID_DEVICE_ID_ALPS_U1:
-	case HID_DEVICE_ID_ALPS_1657:
+	case HID_DEVICE_ID_ALPS_U1_UNICORN_LEGACY:
 		data->dev_type = U1;
 		break;
 	default:
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 7d769ca864a7..b3cc26ca375f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -79,9 +79,9 @@
 #define HID_DEVICE_ID_ALPS_U1_DUAL_PTP	0x121F
 #define HID_DEVICE_ID_ALPS_U1_DUAL_3BTN_PTP	0x1220
 #define HID_DEVICE_ID_ALPS_U1		0x1215
+#define HID_DEVICE_ID_ALPS_U1_UNICORN_LEGACY         0x121E
 #define HID_DEVICE_ID_ALPS_T4_BTNLESS	0x120C
 #define HID_DEVICE_ID_ALPS_1222		0x1222
-#define HID_DEVICE_ID_ALPS_1657         0x121E
 
 #define USB_VENDOR_ID_AMI		0x046b
 #define USB_DEVICE_ID_AMI_VIRT_KEYBOARD_AND_MOUSE	0xff10
-- 
2.25.1



