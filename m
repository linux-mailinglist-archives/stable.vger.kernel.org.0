Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A44207981
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 18:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404431AbgFXQtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 12:49:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:34385 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404017AbgFXQtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 12:49:50 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id 05OGnc6Q011853
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Wed, 24 Jun 2020 09:49:39 -0700 (PDT)
Received: from yow-pgortmak-d1.corp.ad.wrs.com (128.224.56.57) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.487.0; Wed, 24 Jun 2020 09:49:31 -0700
Received: by yow-pgortmak-d1.corp.ad.wrs.com (Postfix, from userid 1000)        id
 89BCE2E065B; Wed, 24 Jun 2020 12:49:31 -0400 (EDT)
Date:   Wed, 24 Jun 2020 12:49:31 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     <stable@vger.kernel.org>
CC:     <songliubraving@fb.com>, <neilb@suse.de>,
        <guoqing.jiang@cloud.ionos.com>
Subject: Please backport 33f2c35a54df to kernels containing c84a1372df92 for
 raid0 compatibility
Message-ID: <20200624164931.GA15350@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I'm recommending backporting commit 33f2c35a54dfd75ad0e7e86918dcbe4de799a56c
("md: add feature flag MD_FEATURE_RAID0_LAYOUT") to any stable kernels with
commit c84a1372df929033cb1a0441fb57bd3932f39ac9 ("md/raid0: avoid RAID0
data corruption due to layout confusion.")

Here is why.  As part of the various recommended mitigation pages out
there, we'll see instructions indicating that using a newer mdadm can
allow one to avoid using the raid0.layout= boot argument.

However, if one does that on a kernel that does *not* contain 33f2c,
then such an older kernel will be "locked out" from mounting the volume
because this test will fail:

	(le32_to_cpu(sb->feature_map) & ~MD_FEATURE_ALL) != 0)

...since the on-disk sb now has MD_FEATURE_RAID0_LAYOUT but the older
kernel knows nothing about it and you get EINVAL (-22) during mount.

I ran into the above situation on a v5.2 kernel, and backporting the
33f2c resolved the locked out issue, and then the bootarg was no longer
required, as documented by the updated mdadm man page.

Thanks,
Paul.
