Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFBE2AE151
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 22:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgKJVDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 16:03:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731788AbgKJVDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 16:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605042227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=GCXyT4rrZonJYVhGP72/OZmW099Kx3vNTtgLrQV7u74=;
        b=GePWnBZznlV0absWFSCmL9g2iPYSOrlkrFmHK5w9ghWpJgRtfgzCM97NIyD7lcqud/5WsD
        +gbk5BHFnFrYwiQtaDJ4+Apwvjg+Q2r8Cy5k9XYJ7oqpqW7/WbtzI030+m52jn58Baw4b1
        XYa6+0w0q+sL9/Na850fKYiBpc1WiZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-Mjw7kU8JPEatcmWzDz011w-1; Tue, 10 Nov 2020 16:03:43 -0500
X-MC-Unique: Mjw7kU8JPEatcmWzDz011w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B90396D248;
        Tue, 10 Nov 2020 21:03:42 +0000 (UTC)
Received: from dqiao.bos.com (ovpn-118-191.rdu2.redhat.com [10.10.118.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 417A85C1C4;
        Tue, 10 Nov 2020 21:03:39 +0000 (UTC)
From:   Donghai Qiao <dqiao@redhat.com>
To:     rhkernel-list@redhat.com
Cc:     Donghai Qiao <dqiao@redhat.com>, Len Brown <len.brown@intel.com>,
        stable@vger.kernel.org
Subject: [RHEL8.4 BZ1844297 CVE-2020-8694 v5] powercap: restrict energy meter to root access
Date:   Tue, 10 Nov 2020 16:03:36 -0500
Message-Id: <20201110210336.14326-1-dqiao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1844297
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
index e85639f004cc..e2150c00b842 100644
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

