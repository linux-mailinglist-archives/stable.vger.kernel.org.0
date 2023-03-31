Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6AD6D1AC3
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 10:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjCaIuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 04:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjCaIuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 04:50:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA741A478;
        Fri, 31 Mar 2023 01:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680252603; x=1711788603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G+kxJZEIE+GVMqJqP/vS09+4cvaoQgOrzIwz7KkJRuE=;
  b=n+TYM3PySxyyKD22LwJEGTGqtcMn3mZ0B+Rr40SWjESrD5Y0zCjRNCW9
   97KM8sI8wjRaPURAZPpSelRUnKR8fPuC4608cNzCXW8/SFytnsxK3XcRo
   JkJtCKcAC34H69hbSJ89xwKtWXel6jE+OD/kap3Yhi++axsIL2xNPLZsG
   Y2al6+TH+Brh5k4h9MBwNqwo7YBIMRSxRew+ALXMAkaV3lRnasVLMiAx7
   hZv5ZiDWn9siXyUJcHW7A5YVLYdlWmH7wYYlgnZ6Swhx8pJTXJ9/asjFq
   QfARlvRaCUdmWDAG8OQA4D9SMGId48NEKDZO3hfNOgctmixE1dK8NOQ7/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="325365066"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="325365066"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 01:49:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="808972514"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="808972514"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 01:49:41 -0700
Received: from kekkonen.localdomain (localhost [IPv6:::1])
        by kekkonen.fi.intel.com (Postfix) with SMTP id B491911FAD0;
        Fri, 31 Mar 2023 11:49:38 +0300 (EEST)
Date:   Fri, 31 Mar 2023 11:49:38 +0300
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Dongchun Zhu <dongchun.zhu@mediatek.com>,
        Jimmy Su <jimmy.su@intel.com>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Max Staudt <mstaudt@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: ov8856: Do not check for for module version
Message-ID: <ZCaeojsCxe39+zVE@kekkonen.localdomain>
References: <20230323-ov8856-otp-v1-0-604f7fd23729@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323-ov8856-otp-v1-0-604f7fd23729@chromium.org>
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

On Thu, Mar 23, 2023 at 11:44:20PM +0100, Ricardo Ribalda wrote:
> It the device is probed in non-zero ACPI D state, the module
> identification is delayed until the first streamon.
> 
> The module identification has two parts: deviceID and version. To rea
> the version we have to enable OTP read. This cannot be done during
> streamon, becase it modifies REG_MODE_SELECT.
> 
> Since the driver has the same behaviour for all the module versions, do
> not read the module version from the sensor's OTP.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0e014f1a8d54 ("media: ov8856: support device probe in non-zero ACPI D state")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

I guess the identification could be done from pre_streamon() callback
instead, but the driver doesn't implement it. But the information isn't
used for anything indeed so I'll just take this.

Thanks.

-- 
Kind regards,

Sakari Ailus
