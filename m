Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D9234CA8B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhC2Iix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234890AbhC2Ihc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D99BD619C1;
        Mon, 29 Mar 2021 08:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007023;
        bh=PApl10GyvEwfYrdjagKR3garNXgNNPAlHSkugc5DqVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URQaIG9a64qU6QurnrA9UKZqV1Kn+YFffpbEOHHg2DHrk09iSGDm1OVVtMT+p60Wd
         EkfSXjKwdCp+1zHhkzo5Ga8GOTnJjx9KpnM5ZzIwvYQJAVAR9dIJWwEVmU1xo+fA5r
         GvT+D7bCy+K4kvvqmFoPTcfO9O0PsjDqztFCWr5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Bharathi <Divya_Bharathi@dell.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 191/254] platform/x86: dell-wmi-sysman: Make it safe to call exit_foo_attributes() multiple times
Date:   Mon, 29 Mar 2021 09:58:27 +0200
Message-Id: <20210329075639.393457577@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2d0c418c91d8c86a1b9fb254dda842ada9919513 ]

During some of the error-exit paths it is possible that
release_attributes_data() will get called multiple times,
which results in exit_foo_attributes() getting called multiple
times.

Make it safe to call exit_foo_attributes() multiple times,
avoiding double-free()s in this case.

Note that release_attributes_data() really should only be called
once during error-exit paths. This will be fixed in a separate patch
and it is good to have the exit_foo_attributes() functions modified
this way regardless.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: Divya Bharathi <Divya_Bharathi@dell.com>
Cc: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321115901.35072-4-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-wmi-sysman/enum-attributes.c    | 3 +++
 drivers/platform/x86/dell-wmi-sysman/int-attributes.c     | 3 +++
 drivers/platform/x86/dell-wmi-sysman/passobj-attributes.c | 3 +++
 drivers/platform/x86/dell-wmi-sysman/string-attributes.c  | 3 +++
 4 files changed, 12 insertions(+)

diff --git a/drivers/platform/x86/dell-wmi-sysman/enum-attributes.c b/drivers/platform/x86/dell-wmi-sysman/enum-attributes.c
index 80f4b7785c6c..091e48c217ed 100644
--- a/drivers/platform/x86/dell-wmi-sysman/enum-attributes.c
+++ b/drivers/platform/x86/dell-wmi-sysman/enum-attributes.c
@@ -185,5 +185,8 @@ void exit_enum_attributes(void)
 			sysfs_remove_group(wmi_priv.enumeration_data[instance_id].attr_name_kobj,
 								&enumeration_attr_group);
 	}
+	wmi_priv.enumeration_instances_count = 0;
+
 	kfree(wmi_priv.enumeration_data);
+	wmi_priv.enumeration_data = NULL;
 }
diff --git a/drivers/platform/x86/dell-wmi-sysman/int-attributes.c b/drivers/platform/x86/dell-wmi-sysman/int-attributes.c
index 75aedbb733be..8a49ba6e44f9 100644
--- a/drivers/platform/x86/dell-wmi-sysman/int-attributes.c
+++ b/drivers/platform/x86/dell-wmi-sysman/int-attributes.c
@@ -175,5 +175,8 @@ void exit_int_attributes(void)
 			sysfs_remove_group(wmi_priv.integer_data[instance_id].attr_name_kobj,
 								&integer_attr_group);
 	}
+	wmi_priv.integer_instances_count = 0;
+
 	kfree(wmi_priv.integer_data);
+	wmi_priv.integer_data = NULL;
 }
diff --git a/drivers/platform/x86/dell-wmi-sysman/passobj-attributes.c b/drivers/platform/x86/dell-wmi-sysman/passobj-attributes.c
index 3abcd95477c0..834b3e82ad9f 100644
--- a/drivers/platform/x86/dell-wmi-sysman/passobj-attributes.c
+++ b/drivers/platform/x86/dell-wmi-sysman/passobj-attributes.c
@@ -183,5 +183,8 @@ void exit_po_attributes(void)
 			sysfs_remove_group(wmi_priv.po_data[instance_id].attr_name_kobj,
 								&po_attr_group);
 	}
+	wmi_priv.po_instances_count = 0;
+
 	kfree(wmi_priv.po_data);
+	wmi_priv.po_data = NULL;
 }
diff --git a/drivers/platform/x86/dell-wmi-sysman/string-attributes.c b/drivers/platform/x86/dell-wmi-sysman/string-attributes.c
index ac75dce88a4c..552537852459 100644
--- a/drivers/platform/x86/dell-wmi-sysman/string-attributes.c
+++ b/drivers/platform/x86/dell-wmi-sysman/string-attributes.c
@@ -155,5 +155,8 @@ void exit_str_attributes(void)
 			sysfs_remove_group(wmi_priv.str_data[instance_id].attr_name_kobj,
 								&str_attr_group);
 	}
+	wmi_priv.str_instances_count = 0;
+
 	kfree(wmi_priv.str_data);
+	wmi_priv.str_data = NULL;
 }
-- 
2.30.1



