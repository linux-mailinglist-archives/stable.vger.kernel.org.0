Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29717343A75
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 08:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCVHVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 03:21:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23325 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhCVHVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 03:21:20 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210322072118epoutp0379c86cb898b4395aa1f01ecfbcaf2b3c~umR-h83j40999609996epoutp03S
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 07:21:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210322072118epoutp0379c86cb898b4395aa1f01ecfbcaf2b3c~umR-h83j40999609996epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616397678;
        bh=FHOZ4FboxVNbnwYVL48PTst9b6QCpMvI/+868hz5+nU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=QnLC6U4tWY1gSOTqzWxyUj/kcHBeOuH8Z24QCiCgxr4HTmPhfwGWUspMOC0WWfduq
         d5WU9ZWF1i+6z2up8EVqUWhX5z0ucyjLqkw1bvPY5x1isjO0yfaS+sGvwT29AqRI66
         Z//jbGFXKuJcDVaUSqh4ziTKwe/PRzJxoq2W1j2g=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210322072117epcas2p328ce071ebc6fc65d5c0b5aa75ce5f2c7~umR_dxEeW3082530825epcas2p3J;
        Mon, 22 Mar 2021 07:21:17 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4F3mBg6w6Yz4x9QJ; Mon, 22 Mar
        2021 07:21:15 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.49.52511.B6548506; Mon, 22 Mar 2021 16:21:15 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210322072114epcas2p26ffb644ee3df243b337c6ae955599cfa~umR8P5E6B0581205812epcas2p28;
        Mon, 22 Mar 2021 07:21:14 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210322072114epsmtrp28b77ddb76cfe33d2d8404e6a1186622b~umR8Ow5KE0445904459epsmtrp2R;
        Mon, 22 Mar 2021 07:21:14 +0000 (GMT)
X-AuditID: b6c32a48-a9948a800000cd1f-d3-6058456b8d0c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A0.A4.13470.A6548506; Mon, 22 Mar 2021 16:21:14 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210322072114epsmtip17736b55ac5e130220955d2d3b90c9929~umR7vC2TP1823618236epsmtip13;
        Mon, 22 Mar 2021 07:21:14 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Ulf Hansson'" <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>,
        "'Rafael J . Wysocki'" <rjw@rjwysocki.net>
Cc:     "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Wolfram Sang'" <wsa+renesas@sang-engineering.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        "'Android Kernel Team'" <kernel-team@android.com>,
        <stable@vger.kernel.org>,
        =?ks_c_5601-1987?B?wMy788f2?= <sh425.lee@samsung.com>,
        =?ks_c_5601-1987?B?vK29wsO2?= <sc.suh@samsung.com>,
        =?ks_c_5601-1987?B?vK3Io7+1?= <hy50.seo@samsung.com>,
        =?ks_c_5601-1987?B?sei6tMjG?= <bhoon95.kim@samsung.com>
In-Reply-To: <20210310152900.149380-1-ulf.hansson@linaro.org>
Subject: RE: [PATCH] mmc: core: Fix hanging on I/O during system suspend for
 removable cards
Date:   Mon, 22 Mar 2021 16:21:13 +0900
Message-ID: <006b01d71eeb$f16c6680$d4453380$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHdOhUB196LQ3U1VfE+AnKrSxL4AwI5OEDFqnGZihA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmmW62a0SCwZf9qhYnn6xhs/i69Bmr
        xerFD1gsdmwXsZjyZzmTxeVdc9gsjvzvZ7T43HuE0eLM6UusFl13bzBaLP33lsViwcZHjBbH
        14Zb9J1zd+Dz2LZ7G6vH4j0vmTzuXNvD5rHlajuLR9+WVYwezxauZ/H4vEkugD0qxyYjNTEl
        tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GAlhbLEnFKgUEBi
        cbGSvp1NUX5pSapCRn5xia1SakFKToGhYYFecWJucWleul5yfq6VoYGBkSlQZUJOxoy5l9gK
        jglUbOy8wt7AuIW3i5GTQ0LAROLqjY0sXYxcHEICOxglfvfOYYNwPjFKXHvwjR3C+cYosXz6
        LaAyDrCWJYelIOJ7GSUmTf4I1fGCUeLvlC9sIHPZBLQlpj3czQpiiwiUS3yafBtsB7NAK4vE
        wx0LWEASnAK2Egt2bmMGsYUF4iTWbNgDFmcRUJU4enoLWDOvgKXEwb5WFghbUOLkzCdgNrOA
        kcSS1fOZIGx5ie1v5zBDPKQg8fPpMqjFVhIbL79mg6gRkZjd2cYMcoSEwBUOiQ2np7JBvOMi
        sf2dKUSvsMSr41vYIWwpic/v9rJB2PUS+6Y2sEL09jBKPN33jxEiYSwx61k7I8QcZYkjt6Bu
        45PoOPyXHSLMK9HRJgRRrSzxa9JkqE5JiZk377BPYFSaheSzWUg+m4Xks1lIPljAyLKKUSy1
        oDg3PbXYqMAEObo3MYKTs5bHDsbZbz/oHWJk4mA8xCjBwawkwnsiOSRBiDclsbIqtSg/vqg0
        J7X4EKMpMLAnMkuJJucD80NeSbyhqZGZmYGlqYWpmZGFkjhvkcGDeCGB9MSS1OzU1ILUIpg+
        Jg5OqQYmRvOX+U0GRssmBYt9bTllmDVr+rFWYcZzldwz2K8vbTX66zTrwAEfk9i/zHt7/5a+
        sv76Kb8xZVN2a/p7BnvLTWIPlh2acGPmk0eOOo++f5qu+6U34qRp/JuAJbqPp1w/vkrQ/IbA
        iTVnp+ZqXZDaeX+B/pI7srafMoTztqfmNbxK4//+1zM3SXljRI+wxZm3XYeeVYne/Pz67v5X
        1YxvT07YKx09jaFtIvv0i3eiytMWPj+dmCvUuM18k7FC6dy23rVsrqVBP5oL78ivSC53M568
        QVMiNeU30wn2faXc91890A5mfSyzuPf0/zenws7VG6Wr2Ir2r7xiu2WTyIvGuHNvdonH3XzI
        kKR0dXVSmRJLcUaioRZzUXEiAHBUiCJXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWy7bCSnG6Wa0SCwdu1BhYnn6xhs/i69Bmr
        xerFD1gsdmwXsZjyZzmTxeVdc9gsjvzvZ7T43HuE0eLM6UusFl13bzBaLP33lsViwcZHjBbH
        14Zb9J1zd+Dz2LZ7G6vH4j0vmTzuXNvD5rHlajuLR9+WVYwezxauZ/H4vEkugD2KyyYlNSez
        LLVI3y6BK2PG3EtsBccEKjZ2XmFvYNzC28XIwSEhYCKx5LBUFyMXh5DAbkaJXZ9OsHUxcgLF
        JSVO7HzOCGELS9xvOcIKUfSMUeLswj9gCTYBbYlpD3ezgtgiApUSf9f3s4EUMQt0skjs73kH
        NklIoI9R4uJXBxCbU8BWYsHObcwgtrBAjMSrs9/ABrEIqEocPb0FbBCvgKXEwb5WFghbUOLk
        zCdgNjPQpY2Hu6FseYntb+cwQ1ynIPHz6TKoI6wkNl5+zQZRIyIxu7ONeQKj8Cwko2YhGTUL
        yahZSFoWMLKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjlEtzR2M21d90DvEyMTB
        eIhRgoNZSYT3RHJIghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2Cy
        TBycUg1MNeHKWZ72D/NSfnXu+3dkYdTuPb8P32x8cuMphwOvXZnsIckqnW37bb9PurfyDuOJ
        iuJbDfJCz7Ick7ZHqFr1iPO+Kdty7u/1Q2LWX1IFpX+0aH3YJFu+avsbJx2dA7orNQNdDi5h
        EP/2a/Elq1y/n8xNc2YsUpu1/43M4Ru7Clf8+OW38K/QPZussu/+UkoxNzWOm6f1JnGW8AXs
        qznvcejb+eKSiJ8uETtmdOpNt6tQvstnovtQW9JGae6Ka1p2Wicst30O4vP6FvyrS99+hjpz
        /Q+fQL+oenPH62yTzznaKO/Ls+HXNzEKL5q6uJHt3ymjvfM/7rnhm5KnzRVTt0vqQjuDXNrm
        6AcVDeJKLMUZiYZazEXFiQB80Jo4QAMAAA==
X-CMS-MailID: 20210322072114epcas2p26ffb644ee3df243b337c6ae955599cfa
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210310152931epcas2p1be7719eeaca8d14bf7a8244ff389bd39
References: <CGME20210310152931epcas2p1be7719eeaca8d14bf7a8244ff389bd39@epcas2p1.samsung.com>
        <20210310152900.149380-1-ulf.hansson@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> The mmc core uses a PM notifier to temporarily during system suspend, turn
> off the card detection mechanism for removal/insertion of (e)MMC/SD/SDIO
> cards. Additionally, the notifier may be used to remove an SDIO card
> entirely, if a corresponding SDIO functional driver don't have the system
> suspend/resume callbacks assigned. This behaviour has been around for a
> very long time.
> 
> However, a recent bug report tells us there are problems with this
> approach. More precisely, when receiving the PM_SUSPEND_PREPARE
> notification, we may end up hanging on I/O to be completed, thus also
> preventing the system from getting suspended.
> 
> In the end what happens, is that the cancel_delayed_work_sync() in
> mmc_pm_notify() ends up waiting for mmc_rescan() to complete - and since
> mmc_rescan() wants to claim the host, it needs to wait for the I/O to be
> completed first.
> 
> Typically, this problem is triggered in Android, if there is ongoing I/O
> while the user decides to suspend, resume and then suspend the system
> again. This due to that after the resume, an mmc_rescan() work gets punted
> to the workqueue, which job is to verify that the card remains inserted
> after the system has resumed.
> 
> To fix this problem, userspace needs to become frozen to suspend the I/O,
> prior to turning off the card detection mechanism. Therefore, let's drop
> the PM notifiers for mmc subsystem altogether and rely on the card
> detection to be turned off/on as a part of the system_freezable_wq, that
> we are already using.
> 
> Moreover, to allow and SDIO card to be removed during system suspend,
> let's manage this from a ->prepare() callback, assigned at the
> mmc_host_class level. In this way, we can use the parent device (the
> mmc_host_class device), to remove the card device that is the child, in
> the
> device_prepare() phase.
> 
> Reported-by: Kiwoong Kim <kwmad.kim@samsung.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>


Reviewed-by: Kiwoong Kim <kwmad.kim@samsung.com>

Thanks.
Kiwoong Kim

