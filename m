Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7A32AE0D9
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 21:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgKJUmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 15:42:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbgKJUmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 15:42:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605040954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=nN7K9eYovR5ebtstOMyH2NZBS19myu7p1oiAq7B3xQY=;
        b=DOUEl2ljTlzvXT4C70sG4V0QekKSDqH7Hr7p2Dm0rdrpl6L/H2tSJ3jziXw6rllZ6xX5fi
        ylQ/aa8jnynm4KTqIgc8gCfgG8nbB7Gb+S2n24KuFJTTX4wpaLou4GMe1bFUIUk/A0uFOt
        +tCdxIpzNdrKueTuq6c1/yGsCP0pO7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-K9QrFiMJO_OrmF9DF1VFIw-1; Tue, 10 Nov 2020 15:42:31 -0500
X-MC-Unique: K9QrFiMJO_OrmF9DF1VFIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A8441007B01;
        Tue, 10 Nov 2020 20:42:30 +0000 (UTC)
Received: from dqiao.bos.com (ovpn-118-191.rdu2.redhat.com [10.10.118.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B05710013C0;
        Tue, 10 Nov 2020 20:42:29 +0000 (UTC)
From:   Donghai Qiao <dqiao@redhat.com>
To:     dqiao@redhat.com
Cc:     Len Brown <len.brown@intel.com>, stable@vger.kernel.org
Subject: [RHEL7.9 BZ1844300 CVE-2020-8694 v5 2/2] powercap: restrict energy meter to root access
Date:   Tue, 10 Nov 2020 15:42:26 -0500
Message-Id: <20201110204226.13389-2-dqiao@redhat.com>
In-Reply-To: <20201110204226.13389-1-dqiao@redhat.com>
References: <20201110204226.13389-1-dqiao@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1844300
Upstream status: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=949dd0104c496fa7c14991a23c03c62e44637e71
Build info: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=32573686
CVE: CVE-2020-8694

author	Len Brown <len.brown@intel.com>	2020-11-10 13:00:00 -0800
committer	Len Brown <len.brown@intel.com>	2020-11-10 11:40:57 -0500
commit	949dd0104c496fa7c14991a23c03c62e44637e71 (patch)
tree	a90cbfb8ceb195e7160105a272122f97bab99980
parent	3d7772ea5602b88c7c7f0a50d512171a2eed6659 (diff)
download	linux-949dd0104c496fa7c14991a23c03c62e44637e71.tar.gz
powercap: restrict energy meter to root access
Remove non-privileged user access to power data contained in
/sys/class/powercap/intel-rapl*/*/energy_uj

Non-privileged users currently have read access to power data and can
use this data to form a security attack. Some privileged
drivers/applications need read access to this data, but don't expose it
to non-privileged users.

For example, thermald uses this data to ensure that power management
works correctly. Thus removing non-privileged access is preferred over
completely disabling this power reporting capability with
CONFIG_INTEL_RAPL=n.

Fixes: 95677a9a3847 ("PowerCap: Fix mode for energy counter")

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: stable@vger.kernel.org

Signed-off-by: Donghai Qiao <dqiao@redhat.com>
---
 drivers/powercap/powercap_sys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index 05ddf8be64a..db69be2892a 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -379,9 +379,9 @@ static void create_power_zone_common_attributes(
 					&dev_attr_max_energy_range_uj.attr;
 	if (power_zone->ops->get_energy_uj) {
 		if (power_zone->ops->reset_energy_uj)
-			dev_attr_energy_uj.attr.mode = S_IWUSR | S_IRUGO;
+			dev_attr_energy_uj.attr.mode = S_IWUSR | S_IRUSR;
 		else
-			dev_attr_energy_uj.attr.mode = S_IRUGO;
+			dev_attr_energy_uj.attr.mode = S_IRUSR;
 		power_zone->zone_dev_attrs[count++] =
 					&dev_attr_energy_uj.attr;
 	}
-- 
2.18.1

