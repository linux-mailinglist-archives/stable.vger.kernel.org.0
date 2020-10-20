Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B132943D9
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 22:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438464AbgJTU12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 16:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438446AbgJTU12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 16:27:28 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190FDC0613CE
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 13:27:28 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kk5so1027222pjb.1
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 13:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ioGSLjjzW1jFusbYT15fLMiEwDxra3dUOLM0YP5dTns=;
        b=ctC9b+I0eQKpi7PDlRDbJOeEhB03t4V1QSeNPan+OcjDvKRZmV3p22hAFwcRaA7UL/
         ymSloojnREJlbau1YEK6xp2tgEQINTeVk4vu+OO1dtLvxRvXI66zeKKRSo1abSRBzPOL
         VBF1Q2n1cUjlj8S5Rkj5SS1OtL8BwwW+U0c2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ioGSLjjzW1jFusbYT15fLMiEwDxra3dUOLM0YP5dTns=;
        b=Y9mwXk7r3mFFSRk1rh4NHvL4i7mmeAV/bAaJJjVb1ZRrGddBUi+TLgYtdXRteh1F2R
         +FJiveFic9LF2KV924R5Uiyfgro6Zoiim/0esBVfACb8i3qfVQzy1vOswx4rgjANBg2K
         Gqkht4i6sD5LtXRLf9qq4ZxmXQwYgWVeWjr4FeRBh37fsF744K661OOGIYqrkbuMf3NA
         HMq0MfPFPVDpyIXGrQNde7trgGwqR9ki9D1SowRfiaJqtTYqdAdGHj/THPZrfTmHbvZN
         DzXc/K9DoNaIXfILG5A3rwYXxOew1O+6Dv2+5rFUyfy0ibm9wH7jhHWtG7X1YCj3D9eR
         lHgA==
X-Gm-Message-State: AOAM533usBOS71c5pj0Xul1kAfiWlruP0hGd0Gg+iHnKnF4z7aw7j+qf
        Dz7JLZHbuJu5IbsZfJ1/Lcftyw==
X-Google-Smtp-Source: ABdhPJysrBcfSRndRfCtxhGte89H6xyh1HTdvueR2tvs+lhSBplzZ5Y9VT3hv2ZZ8nU9l9KHmHWN1g==
X-Received: by 2002:a17:90a:7d09:: with SMTP id g9mr4267pjl.63.1603225647495;
        Tue, 20 Oct 2020 13:27:27 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b16sm2871404pfp.195.2020.10.20.13.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:27:26 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 1/9] lpfc: fix invalid sleeping context in lpfc_sli4_nvmet_alloc
Date:   Tue, 20 Oct 2020 13:27:11 -0700
Message-Id: <20201020202719.54726-2-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020202719.54726-1-james.smart@broadcom.com>
References: <20201020202719.54726-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003caafb05b2200f4e"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000003caafb05b2200f4e
Content-Transfer-Encoding: 8bit

The following calltrace was seen:

BUG: sleeping function called from invalid context at mm/slab.h:494
...
Call Trace:
 dump_stack+0x9a/0xf0
 ___might_sleep.cold.63+0x13d/0x178
 slab_pre_alloc_hook+0x6a/0x90
 kmem_cache_alloc_trace+0x3a/0x2d0
 lpfc_sli4_nvmet_alloc+0x4c/0x280 [lpfc]
 lpfc_post_rq_buffer+0x2e7/0xa60 [lpfc]
 lpfc_sli4_hba_setup+0x6b4c/0xa4b0 [lpfc]
 lpfc_pci_probe_one_s4.isra.15+0x14f8/0x2280 [lpfc]
 lpfc_pci_probe_one+0x260/0x2880 [lpfc]
 local_pci_probe+0xd4/0x180
 work_for_cpu_fn+0x51/0xa0
 process_one_work+0x8f0/0x17b0
 worker_thread+0x536/0xb50
 kthread+0x30c/0x3d0
 ret_from_fork+0x3a/0x50

A prior patch introduced a spin_lock_irqsave(hbalock) in the
lpfc_post_rq_buffer() routine. Call trace is seen as the hbalock
is held with interrupts disabled during a GFP_KERNEL allocation in
lpfc_sli4_nvmet_alloc().

Fix by reordering locking so that hbalock not held when calling
sli4_nvmet_alloc() (aka rqb_buf_list()).

Fixes: 	411de511c694 ("scsi: lpfc: Fix RQ empty firmware trap")
Cc: <stable@vger.kernel.org> # v4.17+
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_mem.c |  4 +---
 drivers/scsi/lpfc/lpfc_sli.c | 10 ++++++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 27ff67e9edae..656f35eb853e 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -588,8 +588,6 @@ lpfc_sli4_rb_free(struct lpfc_hba *phba, struct hbq_dmabuf *dmab)
  * Description: Allocates a DMA-mapped receive buffer from the lpfc_hrb_pool PCI
  * pool along a non-DMA-mapped container for it.
  *
- * Notes: Not interrupt-safe.  Must be called with no locks held.
- *
  * Returns:
  *   pointer to HBQ on success
  *   NULL on failure
@@ -599,7 +597,7 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba)
 {
 	struct rqb_dmabuf *dma_buf;
 
-	dma_buf = kzalloc(sizeof(struct rqb_dmabuf), GFP_KERNEL);
+	dma_buf = kzalloc(sizeof(*dma_buf), GFP_KERNEL);
 	if (!dma_buf)
 		return NULL;
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4cd7ded656b7..4958bb0f2c97 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7248,12 +7248,16 @@ lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 	struct rqb_dmabuf *rqb_buffer;
 	LIST_HEAD(rqb_buf_list);
 
-	spin_lock_irqsave(&phba->hbalock, flags);
 	rqbp = hrq->rqbp;
 	for (i = 0; i < count; i++) {
+		spin_lock_irqsave(&phba->hbalock, flags);
 		/* IF RQ is already full, don't bother */
-		if (rqbp->buffer_count + i >= rqbp->entry_count - 1)
+		if (rqbp->buffer_count + i >= rqbp->entry_count - 1) {
+			spin_unlock_irqrestore(&phba->hbalock, flags);
 			break;
+		}
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+
 		rqb_buffer = rqbp->rqb_alloc_buffer(phba);
 		if (!rqb_buffer)
 			break;
@@ -7262,6 +7266,8 @@ lpfc_post_rq_buffer(struct lpfc_hba *phba, struct lpfc_queue *hrq,
 		rqb_buffer->idx = idx;
 		list_add_tail(&rqb_buffer->hbuf.list, &rqb_buf_list);
 	}
+
+	spin_lock_irqsave(&phba->hbalock, flags);
 	while (!list_empty(&rqb_buf_list)) {
 		list_remove_head(&rqb_buf_list, rqb_buffer, struct rqb_dmabuf,
 				 hbuf.list);
-- 
2.26.2


--0000000000003caafb05b2200f4e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgH2iGkR1T8qGOiPDR
30qTwwZ0lAutDS4OvIYhVl7KB6MwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDIwMjAyNzI3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAG5EGe/lrGV5jTeW5h12pD5dzy8ki3oFjDn0
aYKudHn8Xi5/swi1VfDzBwXkuHfhLCHBbvHdexUXEpJXz5kRLh3XUcIupN9KHpVWhXN6L1K176b2
fy65ubledjawjIySLjmZNJyKZzvqxZvvFPvlSGvPVkWiXhDnpsZ/rI48vW4Ofs1sQ5kaZmqlO3+X
ODxExRlNuoT3EOVRpRSan5fdfoIaYZvlnV1JI9AfVQ5Dm7iGjP0MsXSJN3xTlb+sgFwDE4MUDEqr
DNMtsBj+f2ykXRQXVrq10MsIoCeMWme3NXXo12A1iXs4MHN3JYEmm3vgyWfkcTEoxh6BgSfXFNAF
sXA=
--0000000000003caafb05b2200f4e--
