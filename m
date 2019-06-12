Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C79742852
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 16:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407758AbfFLODh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 10:03:37 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:8991 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2407368AbfFLODh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 10:03:37 -0400
X-UUID: 0ec276bfe8ac41e39318012d65bb6cff-20190612
X-UUID: 0ec276bfe8ac41e39318012d65bb6cff-20190612
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1598698959; Wed, 12 Jun 2019 22:03:32 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 12 Jun 2019 22:03:24 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 12 Jun 2019 22:03:23 +0800
Message-ID: <1560348204.19782.6.camel@mtkswgap22>
Subject: RE: [PATCH v1] scsi: ufs: Avoid runtime suspend possibly being
 blocked forever
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>,
        "ygardi@codeaurora.org" <ygardi@codeaurora.org>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        <stanley.chu@mediatek.com>
Date:   Wed, 12 Jun 2019 22:03:24 +0800
In-Reply-To: <SN6PR04MB492546256F8F8635E7EE60C2FCEC0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1560325326-1598-1-git-send-email-stanley.chu@mediatek.com>
         <SN6PR04MB492546256F8F8635E7EE60C2FCEC0@SN6PR04MB4925.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 4018B39517CC99ADF846BD09B0727C651F76F30778E15F902E6C0D2819EA72F62000:8
X-MTK:  N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Avri,

On Wed, 2019-06-12 at 11:10 +0000, Avri Altman wrote:
> Hi,
> 
> > 
> > UFS runtime suspend can be triggered after pm_runtime_enable()
> > is invoked in ufshcd_pltfrm_init(). However if the first runtime
> > suspend is triggered before binding ufs_hba structure to ufs
> > device structure via platform_set_drvdata(), then UFS runtime
> > suspend will be no longer triggered in the future because its
> > dev->power.runtime_error was set in the first triggering and does
> > not have any chance to be cleared.
> > 
> > To be more clear, dev->power.runtime_error is set if hba is NULL
> > in ufshcd_runtime_suspend() which returns -EINVAL to rpm_callback()
> > where dev->power.runtime_error is set as -EINVAL. In this case, any
> > future rpm_suspend() for UFS device fails because
> > rpm_check_suspend_allowed() fails due to non-zero
> > dev->power.runtime_error.
> > 
> > To resolve this issue, make sure the first UFS runtime suspend
> > get valid "hba" in ufshcd_runtime_suspend(): Enable UFS runtime PM
> > only after hba is successfully bound to UFS device structure.
> > 
> > Fixes: e3ce73d (scsi: ufs: fix bugs related to null pointer access and array size)
> This code was inserted before platform_set_drvdata  in
> 6269473 [SCSI] ufs: Add runtime PM support for UFS host controller driver.
> Why do you point to e3ce73d?

e3ce73d (scsi: ufs: fix bugs related to null pointer access and array
size) changed the returned value from 0 to -EINVAL in case of NULL "hba"
in ufshcd_runtime_suspend().

But you are right, above patch may do the right thing, and the real root
cause is the incorrect timing of pm_runtime_enable().

I will fix commit message in next version.

> 
> Thanks,
> Avri

Thanks.
Stanley


