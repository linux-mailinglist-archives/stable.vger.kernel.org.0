Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5604145E9A
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 23:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAVW0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 17:26:54 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38883 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgAVW0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 17:26:53 -0500
Received: by mail-pg1-f193.google.com with SMTP id a33so273630pgm.5
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 14:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=swWbt3aJL3q8h4lz+/4twKGtWH3pxZbO2/WppH1VqRE=;
        b=K0ohNbHMOAsVb4M6Ck8cIf3BM8XchMabhMit1TMM4M9rA7DOOGd/sgBcVKqk4Dkfyl
         MzkiSn6mrkDn4Rzo4C7qixNHdL/CFF78glRDZyCApSy9ECeubN35sr+56Jowj5rwc1qX
         P0nCx7C1QsIOrrIqxRuZIJCWeIkHckFcMN5GGbk1NVw9Y/JbCuMS4i3CzwgBPRDfpjcq
         SBIyfImGz9ImHeT0LopgirqAnevkSzpfLi+UMd7UT0MkGdqNkR32HmrLKL2wP3KNBLbp
         aDB8LJZb1z0/CHBTLZbYRBbK4qL9hHXMe7uTtYP/yX1g1i8LefORegdQRnX/eR1YsnR8
         UbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=swWbt3aJL3q8h4lz+/4twKGtWH3pxZbO2/WppH1VqRE=;
        b=WMOI8Wss48BW0ruj6qEC/8ot7Qpi2Pw2U0qRvREl8n3ODo2GyT27DfPezNJnYqyRJ5
         yYvW82WHXTBSS/i0dvX2VKygBIWNfUrQd2iCRqyvCJ1oDWRS6f+iZYexat2kLZYEDkjj
         d9oor6RF8rVboMLi8BLI69k/cUWpFYg8Szff38qZn2/tW6s+fO6/oGcfbm5/bx6Q/J80
         yRTC0i9pNMwS4P4FyNBmsgSksIeZ8EB7sCn5sx5f5FfBVUau7KVLpXq2VDln1rBOtrqt
         F2wTKlabJwIO1cFxnsUu0N8+GCdiYpcLqz2U6WGiHwU6PYCqqLgDWIDEY38NVd7SS92P
         S/+A==
X-Gm-Message-State: APjAAAWnNI3bZlFNnIhOXbQ5UD/oPc1e8Rhgdg+syj1wGeHPCLzxFfOY
        Ghd5MlqBBLoIyeqgpA9nSjOdJQ==
X-Google-Smtp-Source: APXvYqxjWJnBDQWDLfs492qyC8m1YgOMNGISqY5eu6Q4wsVKzbqlsokkc0qtDmoQD/wqOD4EOckAOw==
X-Received: by 2002:a62:3892:: with SMTP id f140mr4552209pfa.190.1579732012776;
        Wed, 22 Jan 2020 14:26:52 -0800 (PST)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id a28sm47793509pfh.119.2020.01.22.14.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 14:26:52 -0800 (PST)
From:   John Stultz <john.stultz@linaro.org>
To:     lkml <linux-kernel@vger.kernel.org>
Cc:     Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [RFC][PATCH 2/2] usb: dwc3: gadget: Correct the logic for finding last SG entry
Date:   Wed, 22 Jan 2020 22:26:45 +0000
Message-Id: <20200122222645.38805-3-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122222645.38805-1-john.stultz@linaro.org>
References: <20200122222645.38805-1-john.stultz@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>

As a process of preparing TRBs usb_gadget_map_request_by_dev() is
called from dwc3_prepare_trbs() for mapping the request. This will
call dma_map_sg() if req->num_sgs are greater than 0. dma_map_sg()
will map the sg entries in sglist and return the number of mapped SGs.
As a part of mapping, some sg entries having contigous memory may be
merged together into a single sg (when IOMMU used). So, the number of
mapped sg entries may not be equal to the number of orginal sg entries
in the request (req->num_sgs).

As a part of preparing the TRBs, dwc3_prepare_one_trb_sg() iterates over
the sg entries present in the sglist and calls sg_is_last() to identify
whether the sg entry is last and set IOC bit for the last sg entry. The
sg_is_last() determines last sg if SG_END is set in sg->page_link. When
IOMMU used, dma_map_sg() merges 2 or more sgs into a single sg and it
doesn't retain the page_link properties. Because of this reason the
sg_is_last() may not find SG_END and thus resulting in IOC bit never
getting set.

For example:

Consider a request having 8 sg entries with each entry having a length of
4096 bytes. Assume that sg1 & sg2, sg3 & sg4, sg5 & sg6, sg7 & sg8 are
having contigous memory regions.

Before calling dma_map_sg():
            sg1-->sg2-->sg3-->sg4-->sg6-->sg7-->sg8
dma_length: 4K    4K    4K    4K    4K    4K    4K
SG_END:     False False False False False False True
num_sgs = 8
num_mapped_sgs = 0

The dma_map_sg() merges sg1 & sg2 memory regions into sg1->dma_address.
Similarly sg3 & sg4 into sg2->dma_address, sg5 & sg6 into the
sg3->dma_address and sg6 & sg8 into sg4->dma_address. Here the memory
regions are merged but the page_link properties like SG_END are not
retained into the merged sgs.

After calling dma_map_sg();
            sg1-->sg2-->sg3-->sg4-->sg6-->sg7-->sg8
dma_length: 8K    8K    8K    8K    0K    0K     0K
SG_END:     False False False False False False True
num_sgs = 8
num_mapped_sgs = 4

After calling dma_map_sg(), sg1,sg2,sg3,sg4 are having dma_length of
8096 bytes each and remaining sg4,sg5,sg6,sg7 are having 0 bytes of
dma_length.

After dma_map_sg() is performed dma_perpare_trb_sg() iterates on all sg
entries and sets IOC bit only for the sg8 (since sg_is_last() returns true
only for sg8). But after calling dma_map_sg() the valid data are present
only till sg4 and the IOC bit should be set for sg4 TRB only (which is not
happening in the present code)

The above mentioned issue can be fixed by determining last sg based on the
req->num_queued_sgs instead of sg_is_last(). If (req->num_queued_sgs + 1)
is equal to req->num_mapped_sgs, then this sg is the last sg. In the above
example, the dwc3 driver has already queued 3 sgs (upto sg3), so the
num_queued_sgs = 3. On preparing the next sg (i.e sg4), check for last sg
(num_queued_sgs + 1) == num_mapped_sgs becomes true. So, the driver sets
IOC bit for sg4. This patch does the same.

At a practical level, this patch resolves USB transfer stalls
seen with adb on dwc3 based db845c, pixel3 and other qcom
hardware after functionfs gadget added scatter-gather support
around v4.20.

Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Yang Fei <fei.yang@intel.com>
Cc: Thinh Nguyen <thinhn@synopsys.com>
Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: Jack Pham <jackp@codeaurora.org>
Cc: Todd Kjos <tkjos@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux USB List <linux-usb@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
[jstultz: Add note to end of commit message on specific issue this resovles]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 1edce3bbb55c..30a80bc97cfe 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1068,7 +1068,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 		unsigned int rem = length % maxp;
 		unsigned chain = true;
 
-		if (sg_is_last(s))
+		if ((req->num_queued_sgs + 1) == req->request.num_mapped_sgs)
 			chain = false;
 
 		if (rem && usb_endpoint_dir_out(dep->endpoint.desc) && !chain) {
-- 
2.17.1

