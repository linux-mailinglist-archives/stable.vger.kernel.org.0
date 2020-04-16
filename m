Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7013D1AB5D2
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 04:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731711AbgDPCVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 22:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731550AbgDPCVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 22:21:20 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01EFB2076D;
        Thu, 16 Apr 2020 02:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587003679;
        bh=zaERmn/D2XCvsqxtDjbwXdine0SWlExcjHCQrIIjn7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0BVgjFZi45XxEDhsHeflFVGPRMTKAGlKnIVZXOxj77Rt9RzCf80nk9dEurgzodXBi
         Lk3+wC3Mz2WZglc0HKBVAAOQ1YlGuYlVpyGQjlqtJetDUAR6jjk1K/z14m+Lds6/Fb
         iB7AL8vV0y/5TS1ZFGAAg+b504J5SYZiAhwTWiGs=
Date:   Wed, 15 Apr 2020 22:21:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lyude@redhat.com, Wayne.Lin@amd.com, sean@poorly.run,
        ville.syrjala@linux.intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/dp_mst: Fix clearing payload state on
 topology disable" failed to apply to 5.6-stable tree
Message-ID: <20200416022117.GX1068@sasha-vm>
References: <1586950297139145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1586950297139145@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:31:37PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 8732fe46b20c951493bfc4dba0ad08efdf41de81 Mon Sep 17 00:00:00 2001
>From: Lyude Paul <lyude@redhat.com>
>Date: Wed, 22 Jan 2020 14:43:20 -0500
>Subject: [PATCH] drm/dp_mst: Fix clearing payload state on topology disable
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>The issues caused by:
>
>commit 64e62bdf04ab ("drm/dp_mst: Remove VCPI while disabling topology
>mgr")
>
>Prompted me to take a closer look at how we clear the payload state in
>general when disabling the topology, and it turns out there's actually
>two subtle issues here.
>
>The first is that we're not grabbing &mgr.payload_lock when clearing the
>payloads in drm_dp_mst_topology_mgr_set_mst(). Seeing as the canonical
>lock order is &mgr.payload_lock -> &mgr.lock (because we always want
>&mgr.lock to be the inner-most lock so topology validation always
>works), this makes perfect sense. It also means that -technically- there
>could be racing between someone calling
>drm_dp_mst_topology_mgr_set_mst() to disable the topology, along with a
>modeset occurring that's modifying the payload state at the same time.
>
>The second is the more obvious issue that Wayne Lin discovered, that
>we're not clearing proposed_payloads when disabling the topology.
>
>I actually can't see any obvious places where the racing caused by the
>first issue would break something, and it could be that some of our
>higher-level locks already prevent this by happenstance, but better safe
>then sorry. So, let's make it so that drm_dp_mst_topology_mgr_set_mst()
>first grabs &mgr.payload_lock followed by &mgr.lock so that we never
>race when modifying the payload state. Then, we also clear
>proposed_payloads to fix the original issue of enabling a new topology
>with a dirty payload state. This doesn't clear any of the drm_dp_vcpi
>structures, but those are getting destroyed along with the ports anyway.
>
>Changes since v1:
>* Use sizeof(mgr->payloads[0])/sizeof(mgr->proposed_vcpis[0]) instead -
>  vsyrjala
>
>Cc: Sean Paul <sean@poorly.run>
>Cc: Wayne Lin <Wayne.Lin@amd.com>
>Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
>Cc: stable@vger.kernel.org # v4.4+
>Signed-off-by: Lyude Paul <lyude@redhat.com>
>Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
>Link: https://patchwork.freedesktop.org/patch/msgid/20200122194321.14953-1-lyude@redhat.com

We needed a86675968e23 ("Revert "drm/dp_mst: Remove VCPI while disabling
topology mgr"") too (this is a revert of a stable tagged commit).

-- 
Thanks,
Sasha
