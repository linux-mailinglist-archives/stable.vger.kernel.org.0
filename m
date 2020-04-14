Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75DC1A70AC
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 03:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403862AbgDNBuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 21:50:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33657 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgDNBun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 21:50:43 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200414015040epoutp02b0d7121e80c4493444a039725865ed12~FjJrMbPZx1484514845epoutp02I
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 01:50:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200414015040epoutp02b0d7121e80c4493444a039725865ed12~FjJrMbPZx1484514845epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586829040;
        bh=GHjLAi8hxP21yj4r7CxqCs6RXPXOcWC+4bCha1I/O+k=;
        h=From:To:Cc:Subject:Date:References:From;
        b=cFcMPtEdqk4w47rc7J8UZvydPhugB3akbfvbrxTKPPATOjG5nFpW1iODMgMRSgq+n
         Uga6n0ds9mK9YvJBJmWhKl9Fhy3cM+ffeo+lTy+wM48IkH5Y8vE+0Agz7ZvSb3A3QZ
         uM9dX61pBv0iRT2AyLOIX7DnvcGaeU+uq1WDpcXk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200414015039epcas2p3dfac1e2d258384c6aad5510dcbea928b~FjJqUiySw2295722957epcas2p3b;
        Tue, 14 Apr 2020 01:50:39 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 491T315YpBzMqYlh; Tue, 14 Apr
        2020 01:50:37 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.9F.04393.AE6159E5; Tue, 14 Apr 2020 10:50:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200414015034epcas2p4a1c9ae1ff679108ff2290cd95c15ccd1~FjJltl6gb0971809718epcas2p46;
        Tue, 14 Apr 2020 01:50:34 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200414015034epsmtrp11403b99f2e99c79eacf18cdffd53e635~FjJlsBbis1383413834epsmtrp1e;
        Tue, 14 Apr 2020 01:50:34 +0000 (GMT)
X-AuditID: b6c32a47-67fff70000001129-fb-5e9516ea4048
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C5.39.04158.AE6159E5; Tue, 14 Apr 2020 10:50:34 +0900 (KST)
Received: from KORDO025540 (unknown [12.36.182.130]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200414015034epsmtip10245e9f248471edee3480feb8c57dc10~FjJliY4IO2790227902epsmtip1D;
        Tue, 14 Apr 2020 01:50:34 +0000 (GMT)
From:   "Gyeongtaek Lee" <gt82.lee@samsung.com>
To:     <stable@vger.kernel.org>
Cc:     <broonie@kernel.org>, <tiwai@suse.com>, <tkjung@samsung.com>,
        <hmseo@samsung.com>, <tkjung@samsung.com>, <kimty@samsung.com>
Subject: [PATCH 3/4] ASoC: dpcm: allow start or stop during pause for
 backend
Date:   Tue, 14 Apr 2020 10:50:34 +0900
Message-ID: <000701d611ff$163c6dc0$42b54940$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdYR/xIrS5BlH3HwShyirspPCXiHHQ==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmme4rsalxBm936VhMffiEzWLGtm4W
        i9VXtzBZLNj4iNFiw/e1jBZHGqcwObB5bFrVyebRt2UVo8f6LVdZPD5vkgtgicqxyUhNTEkt
        UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
        VtK3synKLy1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMnof7SYqeAX
        b0XD9X/sDYy3uLsYOTkkBEwkfuw9xNbFyMUhJLCDUWL37sNMEM4nRom1u85BZb4xSmya/BQo
        wwHWcn0hVHwvo0TP/mVQzktGiWv3HrOBzGUT0JX4cu8OM4gtIiAjMb11LxOIzSzQxCjR3OED
        YgsL+EscmrEWLM4ioCpxc+4BVhCbV8BSoun3A3YIW1Di5MwnLBC98hLb385hhrhbQeLn02Ws
        IAeJCOhJfJjNAVEiIjG7s40Z5B4JgRNsEmunL2KBONpF4sccEYhWYYlXx7ewQ9hSEi/729gh
        6psZJd6d/QOVmMIo0dktBGEbS2yZewrseWYBTYn1u/QhRipLHLkFdRmfRMfhv+wQYV6Jjjao
        RiWJjaf+QUNNQmLeBqjZHhLT7n9nncCoOAvJi7OQvDgLyS+zENYuYGRZxSiWWlCcm55abFRg
        jBzTmxjBqVLLfQfjtnM+hxgFOBiVeHhfBE6JE2JNLCuuzD3EKMHBrCTC+6R8YpwQb0piZVVq
        UX58UWlOavEhRlNgDExklhJNzgem8bySeENTIzMzA0tTC1MzIwslcd5N3DdjhATSE0tSs1NT
        C1KLYPqYODilGhg9nW1uX7J0M9hR6nFP1/6n6AOVgqXld1fPDI8wuhy54vTsgqjrS2r4uT6t
        CT+uZZ6q8W0ld9fO1wdEd22d/eu+5MZNfAfX5u6M33F7/kvPT+WhU7g7vdbql7xQiHj5ZfOx
        8psCX2Mc350QYprybe/5LJfZv/3nXwvUzDc/8f6gr3P+vytbLOaJKLEUZyQaajEXFScCAJV1
        FParAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSnO4rsalxBt1T+S2mPnzCZjFjWzeL
        xeqrW5gsFmx8xGix4ftaRosjjVOYHNg8Nq3qZPPo27KK0WP9lqssHp83yQWwRHHZpKTmZJal
        FunbJXBl9D9azFTwi7ei4fo/9gbGW9xdjBwcEgImEtcXsnUxcnEICexmlFh3vYuli5ETKC4h
        8WH+GXYIW1jifssRVoii54wSC66tYQJJsAnoSny5d4cZxBYRkJGY3roXLM4s0MUosf6UGogt
        LOAr8XTyQrBBLAKqEjfnHmAFsXkFLCWafj9gh7AFJU7OfMICchCzgJ5E20ZGiDHyEtvfzmGG
        uEFB4ufTZawgJSJAJR9mc0CUiEjM7mxjnsAoOAvJoFkIg2YhGTQLSccCRpZVjJKpBcW56bnF
        hgVGeanlesWJucWleel6yfm5mxjBMaCltYPxxIn4Q4wCHIxKPLwT/KfECbEmlhVX5h5ilOBg
        VhLhfVI+MU6INyWxsiq1KD++qDQntfgQozQHi5I4r3z+sUghgfTEktTs1NSC1CKYLBMHp1QD
        Y+Pm7H7XsrhLhhOCFh/9nfV0U82vmdck1qWVPvugcUiqOWIRSzl7zryVBU7zPm28mcHJzWnw
        eZHy5ifpH/henbuVtbU+JjllUkvj8hNMxzasZ5zakO12NfH8n6JK2bh3Z0+sLbr64MXaxzum
        fWO/enUTd6uQj+piq/WV/nuvL9qvefV+x8qm1MNKLMUZiYZazEXFiQDhhqUzfQIAAA==
X-CMS-MailID: 20200414015034epcas2p4a1c9ae1ff679108ff2290cd95c15ccd1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200414015034epcas2p4a1c9ae1ff679108ff2290cd95c15ccd1
References: <CGME20200414015034epcas2p4a1c9ae1ff679108ff2290cd95c15ccd1@epcas2p4.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

soc_compr_trigger_fe() allows start or stop after pause_push.
In dpcm_be_dai_trigger(), however, only pause_release is allowed
command after pause_push.
So, start or stop after pause in compress offload is always
returned as error if the compress offload is used with dpcm.
To fix the problem, SND_SOC_DPCM_STATE_PAUSED should be allowed
for start or stop command.

Signed-off-by: Gyeongtaek Lee <gt82.lee@samsung.com>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/004d01d607c1$7a3d5250$6eb7f6f0$@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/soc-pcm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index d978df95c5c6..cc4e9aa80fb0 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2222,7 +2222,8 @@ int dpcm_be_dai_trigger(struct snd_soc_pcm_runtime *fe, int stream,
 		switch (cmd) {
 		case SNDRV_PCM_TRIGGER_START:
 			if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_PREPARE) &&
-			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP))
+			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP) &&
+			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED))
 				continue;
 
 			ret = dpcm_do_trigger(dpcm, be_substream, cmd);
@@ -2252,7 +2253,8 @@ int dpcm_be_dai_trigger(struct snd_soc_pcm_runtime *fe, int stream,
 			be->dpcm[stream].state = SND_SOC_DPCM_STATE_START;
 			break;
 		case SNDRV_PCM_TRIGGER_STOP:
-			if (be->dpcm[stream].state != SND_SOC_DPCM_STATE_START)
+			if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_START) &&
+			    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED))
 				continue;
 
 			if (!snd_soc_dpcm_can_be_free_stop(fe, be, stream))
-- 
2.21.0


