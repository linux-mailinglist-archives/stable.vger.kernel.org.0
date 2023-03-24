Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6586C7E79
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 14:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjCXNKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 09:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCXNKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 09:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9481795;
        Fri, 24 Mar 2023 06:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23AA662ACB;
        Fri, 24 Mar 2023 13:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979ACC433D2;
        Fri, 24 Mar 2023 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679663417;
        bh=F0HFFIS62//+IDqQarAuRmb4u+Etmm9kj8vJ4jyMrVY=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=KNRX96BfZOHJpemk4BPtqYbiYzfz+E+F9ajdXWKCVSrwZ1qiXrUHjUAtXY/3Sz6LG
         l+oTBqGBSK/OCpWMDAqtpage16IZT4lncVS+nwyBETT4ZaFHNf41Jn+SIASll3mMcI
         iZ31FtHtpdQdDTsumsQAyZe3g6nDIj5lUeAd85fLrLfcbGgA2HnFsGOoMYeKi8BBxl
         7vzXiwXUGGBlu0OIX9QCQnmLSrvfB4374pnvkb38AkBDmsv9IiDn2ViP/YRGMOM3Ve
         V46+hG/38UeCyBQvmP2YyRXLgHyRjF5GF4a2JExT+lqPUL3xujI8GA+Kg3eEvTJ1CL
         LAA1xvx3vaU2A==
Date:   Fri, 24 Mar 2023 14:10:13 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Todd Brandt <todd.e.brandt@intel.com>
cc:     linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, todd.e.brandt@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, jic23@kernel.org,
        p.jungkamp@gmx.net, stable@vger.kernel.org
Subject: Re: [PATCH v4] HID:hid-sensor-custom: Fix buffer overrun in device
 name
In-Reply-To: <20230314181256.15283-1-todd.e.brandt@intel.com>
Message-ID: <nycvar.YFH.7.76.2303241409580.1142@cbobk.fhfr.pm>
References: <20230314181256.15283-1-todd.e.brandt@intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Mar 2023, Todd Brandt wrote:

> On some platforms there are some platform devices created with
> invalid names. For example: "HID-SENSOR-INT-020b?.39.auto" instead
> of "HID-SENSOR-INT-020b.39.auto"
> 
> This string include some invalid characters, hence it will fail to
> properly load the driver which will handle this custom sensor. Also
> it is a problem for some user space tools, which parses the device
> names from ftrace and dmesg.
> 
> This is because the string, real_usage, is not NULL terminated and
> printed with %s to form device name.
> 
> To address this, initialize the real_usage string with 0s.
> 
> Reported-and-tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217169
> Fixes: 98c062e82451 ("HID: hid-sensor-custom: Allow more custom iio sensors")
> Cc: stable@vger.kernel.org
> Suggested-by: Philipp Jungkamp <p.jungkamp@gmx.net>
> Signed-off-by: Philipp Jungkamp <p.jungkamp@gmx.net>
> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
> Changes in v4:
> - add the Fixes line
> - add patch version change list
> Changes in v3:
> - update the changelog
> - add proper reviewed/signed/suggested links
> Changes in v2:
> - update the changelog

Applied to for-6.3/upstream-fixes, thanks.

-- 
Jiri Kosina
SUSE Labs

