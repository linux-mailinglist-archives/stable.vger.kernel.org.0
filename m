Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842D92CC6ED
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 20:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgLBTqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 14:46:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbgLBTqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 14:46:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606938320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lA0ydaBg0956OpL7A6r+mr0eo7Xz85q4haUdiWa+cHg=;
        b=YcyBDH5ELuvzdGn3jxCTt1mvjq57/PwNM/Sspc+rD/Y+jmldGZYTBd2qCAeFTptuLo1WWG
        MpC3Rb0UVKvJMidqLzBy/i3pCt9r+5IqC0i0JAz30XeijqYYDSpCh5JaTGfqsc1FooLR2L
        4aruJvBvUDLFZv6Q7CXXTS+vtL+t3mg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-OuaJIIsTOvuD2TZnLwENFA-1; Wed, 02 Dec 2020 14:45:18 -0500
X-MC-Unique: OuaJIIsTOvuD2TZnLwENFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 778D1805C09;
        Wed,  2 Dec 2020 19:45:17 +0000 (UTC)
Received: from dhcp40-158.desklab.eng.bos.redhat.com (unknown [10.19.40.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D2AE1002391;
        Wed,  2 Dec 2020 19:45:13 +0000 (UTC)
Received: from dhcp40-158.desklab.eng.bos.redhat.com (localhost [127.0.0.1])
        by dhcp40-158.desklab.eng.bos.redhat.com (8.15.2/8.14.8) with ESMTP id 0B2JjCae103279;
        Wed, 2 Dec 2020 14:45:12 -0500
Received: (from tcamuso@localhost)
        by dhcp40-158.desklab.eng.bos.redhat.com (8.15.2/8.15.2/Submit) id 0B2Jj7Dr103278;
        Wed, 2 Dec 2020 14:45:07 -0500
X-Authentication-Warning: dhcp40-158.desklab.eng.bos.redhat.com: tcamuso set sender to tcamuso@redhat.com using -f
Date:   Wed, 2 Dec 2020 14:45:07 -0500
From:   Tony Camuso <tcamuso@redhat.com>
To:     Donghai Qiao <dqiao@redhat.com>
Cc:     rhkernel-list@redhat.com, Len Brown <len.brown@intel.com>,
        stable@vger.kernel.org
Subject: Re: [RHEL8.4 BZ1844297 CVE-2020-8694 v5] powercap: restrict energy
 meter to root access
Message-ID: <20201202194507.GH6736@dhcp40-158.desklab.eng.bos.redhat.com>
References: <20201110210336.14326-1-dqiao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110210336.14326-1-dqiao@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 04:03:36PM -0500, Donghai Qiao wrote:
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1844297
> Upstream status: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=949dd0104c496fa7c14991a23c03c62e44637e71
> Build info: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=32573686
> CVE: CVE-2020-8694
> 
> author	Len Brown <len.brown@intel.com>	2020-11-10 13:00:00 -0800
> committer	Len Brown <len.brown@intel.com>	2020-11-10 11:40:57 -0500
> commit	949dd0104c496fa7c14991a23c03c62e44637e71 (patch)
> tree	a90cbfb8ceb195e7160105a272122f97bab99980
> parent	3d7772ea5602b88c7c7f0a50d512171a2eed6659 (diff)
> download	linux-949dd0104c496fa7c14991a23c03c62e44637e71.tar.gz
> powercap: restrict energy meter to root access
> Remove non-privileged user access to power data contained in
> /sys/class/powercap/intel-rapl*/*/energy_uj
> 
> Non-privileged users currently have read access to power data and can
> use this data to form a security attack. Some privileged
> drivers/applications need read access to this data, but don't expose it
> to non-privileged users.
> 
> For example, thermald uses this data to ensure that power management
> works correctly. Thus removing non-privileged access is preferred over
> completely disabling this power reporting capability with
> CONFIG_INTEL_RAPL=n.
> 
> Fixes: 95677a9a3847 ("PowerCap: Fix mode for energy counter")
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Donghai Qiao <dqiao@redhat.com>
> ---
>  drivers/powercap/powercap_sys.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
> index e85639f004cc..e2150c00b842 100644
> --- a/drivers/powercap/powercap_sys.c
> +++ b/drivers/powercap/powercap_sys.c
> @@ -379,9 +379,9 @@ static void create_power_zone_common_attributes(
>  					&dev_attr_max_energy_range_uj.attr;
>  	if (power_zone->ops->get_energy_uj) {
>  		if (power_zone->ops->reset_energy_uj)
> -			dev_attr_energy_uj.attr.mode = S_IWUSR | S_IRUGO;
> +			dev_attr_energy_uj.attr.mode = S_IWUSR | S_IRUSR;
>  		else
> -			dev_attr_energy_uj.attr.mode = S_IRUGO;
> +			dev_attr_energy_uj.attr.mode = S_IRUSR;
>  		power_zone->zone_dev_attrs[count++] =
>  					&dev_attr_energy_uj.attr;
>  	}
> -- 
> 2.18.1
> 

Acked-by: Tony Camuso <tcamuso@redhat.com>

