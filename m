Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1921D2943DD
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 22:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438437AbgJTU1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 16:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438470AbgJTU1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 16:27:30 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3F1C0613CE
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 13:27:30 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b26so99377pff.3
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 13:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=6vl+T3ZkH2rgdM6cEpe22RpENDBJ4mndr9+lPNGjYiE=;
        b=OiOp7I8GnVhKUcah19AyJU5jxeOVgVyZAliQjWX7l0Tk1Dki20JAr/CNu/KckdJjv2
         MTylvh0rs6DpzndD5K6wRL+Ub5evr5ZIG+QNcGafSeu6E+TCFRM1Ddd05IBS5+gGxEiu
         Wjv7a38YQUAchUB4SMdSIni9R5JTuNHKGx5jQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=6vl+T3ZkH2rgdM6cEpe22RpENDBJ4mndr9+lPNGjYiE=;
        b=KyTn/7LFXpbDtz97HoeBTCNcDoLXRL5i/zMGbjIG3odJ2nPKYFDtJNyDg/JsACmDvo
         PkaW5c9ySx2hSJLLQs3N8kih44tWu0AHDycQzv38poPC/IReTfsvCjn/VGfkPd9u2KGP
         6uAvkzrm+NoxcSbujgaI6eDMD4uOOZL80h1FR3LzmA9Fz0H3YI8ocELVoP+aqLrj0QSZ
         amrTJG7Egh4Da7rsbRXG76rTFTQVfqQS0z50jlEau7k06SQZO3kUSlK0I6/CqFLtB7vT
         XnWHNISXcmzTQB/8L75dzddWiSjWN08BrRTmq4qVeGIfA8qh1ZBoBaWrSAPNf24tdr6b
         WtMA==
X-Gm-Message-State: AOAM533a0lileEd0dcwsXhA33qw6HA2G6isZqhbHUP3fjKpGio0jPrze
        GjR6nywDwXv7XxoBK74Gg3yH77APaSUQzw==
X-Google-Smtp-Source: ABdhPJxGM8WXfA6ckUsAX0hlGG6BwT+PzWELGmRMawZPWp7Uyes84e469CIoXJ9wYunFmK7/xKPhEA==
X-Received: by 2002:a62:cd46:0:b029:150:ddeb:646b with SMTP id o67-20020a62cd460000b0290150ddeb646bmr4254524pfg.27.1603225650225;
        Tue, 20 Oct 2020 13:27:30 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b16sm2871404pfp.195.2020.10.20.13.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:27:29 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>, stable@vger.kernel.org
Subject: [PATCH 3/9] lpfc: Re-fix use after free in lpfc_rq_buf_free()
Date:   Tue, 20 Oct 2020 13:27:13 -0700
Message-Id: <20201020202719.54726-4-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020202719.54726-1-james.smart@broadcom.com>
References: <20201020202719.54726-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000067b35f05b2200f11"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000067b35f05b2200f11
Content-Transfer-Encoding: 8bit

A commit (9816ef6ecbc1) was made to correct a use after free condition
in lpfc_rq_buf_free(). Unfortunately, a subsequent patch cut on a tree
without the fix inadvertantly reverted the fix.

Put the fix back:  move the freeing of the rqb_entry to after the print
function that references it.

Fixes: 	411de511c694 ("scsi: lpfc: Fix RQ empty firmware trap")
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 79386e294fb9..be54fbf5146f 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -721,7 +721,6 @@ lpfc_rq_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 	drqe.address_hi = putPaddrHigh(rqb_entry->dbuf.phys);
 	rc = lpfc_sli4_rq_put(rqb_entry->hrq, rqb_entry->drq, &hrqe, &drqe);
 	if (rc < 0) {
-		(rqbp->rqb_free_buffer)(phba, rqb_entry);
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"6409 Cannot post to HRQ %d: %x %x %x "
 				"DRQ %x %x\n",
@@ -731,6 +730,7 @@ lpfc_rq_buf_free(struct lpfc_hba *phba, struct lpfc_dmabuf *mp)
 				rqb_entry->hrq->entry_count,
 				rqb_entry->drq->host_index,
 				rqb_entry->drq->hba_index);
+		(rqbp->rqb_free_buffer)(phba, rqb_entry);
 	} else {
 		list_add_tail(&rqb_entry->hbuf.list, &rqbp->rqb_buffer_list);
 		rqbp->buffer_count++;
-- 
2.26.2


--00000000000067b35f05b2200f11
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgVRFGObuvDO0r3oxK
0XxJcxE2H5eHcx8ZFj+CB+GxFJwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDIwMjAyNzMwWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAE+Q12qj0cZ6sXDLsBdHquXTNnxLKflMrmcS
1EIc/lnvNvliEjtXl9GbZYV1G9BZavLyz1XEDp4I666faYQgFl0mfGJFNw1LEzCg374QZP7E1K97
E5PSS9uxVQSwO+nAEvXA/eo+3iIgB3qV1cNH92+Ey03fytEdk2QvOdcSevcLWmN5LGIzmhIxYm99
pNbkPU3yOoInZHQolS6GsQlI3rsBKmWaFIuBRTRPncYr/LDGUnEH0ZSROS8yTT0M6lG8khbMiRoI
cmtZC8Wx9EsIfa6gqQokgRguk6SKsWOGUr7Crww7koX0igewZ6KalGcTRGXOnwuBQasVVq5GfT/Q
IYA=
--00000000000067b35f05b2200f11--
