Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A440E5A8D14
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiIAFIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiIAFId (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:08:33 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33730112ED5
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 22:08:32 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c59so14800336edf.10
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 22:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0n5+v3nbjIov4RPCmA704cWIUoaLaSOoiKchWEmgUBU=;
        b=FHtg2nSAtu+mYBEqx6tcDLfiV9Uarj7qoFzWrpu4PiFEjY2v/uZHaFnfPgdl3kYP5t
         XwgQCLachme0pvSt7oPtvVXiOAjie7KwL3lk5MkBUdSnPREVxzYvMwrVxt0fIuyEECtt
         3WDM+YLJ1Ii7PUUxOkT/xTdpvjrrDhrJw36N8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0n5+v3nbjIov4RPCmA704cWIUoaLaSOoiKchWEmgUBU=;
        b=37Nr73J9EOAsd1XD+wcZ5Cx6xcyLqu3t5GqGqHgDp8MzVM9bh0oB9taSf2b9GIEQEM
         8SzxMTFE37DbisU1qJjo5ePvMfO1bQPMkq9QFUj1Rr5e/5kzYbYxzL4ChVU3RuQMr4Xn
         KqlYKKX4bP5Hv02dtgyHfZIVGUzW1KWSSlmJ0O9kH5OUnz7VsGxqQG+k7G1BD6JHEMff
         heMnnnmv40fYLJ4HZTu5y6RveSGjYvVANxdW5yDyAh2tdRY+LxfozBMdd1wH2LI9sDqA
         qpZJCAtwHvhWmq8+MGfUNdxrUFE2UZBALlJnuG/d1UBy3etR82xL20CRi1vlIQaQzYDM
         0kaQ==
X-Gm-Message-State: ACgBeo06vd8sHhW6KG6v8cmNJR4PTQUqsTEfMtjjfxY8pfaD6CgdHnmJ
        SlBFH0H8A6DuiPLLshUPDN+eysRB225wmR1BTm0QZCW6xSPf5bRceAVMzpoq5K9CbVsJGeHNcly
        df9WJXZRdR7tUrJS22KUP8A==
X-Google-Smtp-Source: AA6agR6Hg4p3kqa0Bzu0bPb6v6Ymp7+v17GWbnjWdVbsPPMeD6/wsjJFnMLaA2E/q/njxj89y+eNKpcLKoUSrW1wlcM=
X-Received: by 2002:a50:fa87:0:b0:447:87f3:ee7e with SMTP id
 w7-20020a50fa87000000b0044787f3ee7emr28203981edr.182.1662008910651; Wed, 31
 Aug 2022 22:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220825092645.326953-1-15815827059@163.com> <49b0768d.96d.182f69a26f6.Coremail.15815827059@163.com>
In-Reply-To: <49b0768d.96d.182f69a26f6.Coremail.15815827059@163.com>
From:   Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date:   Wed, 31 Aug 2022 23:08:14 -0600
Message-ID: <CAFdVvOzAWcFLgPi_y8HW5Jx5JbC1AgBtADnwvd9usq8veU0vOg@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix NULL pointer crash due to missing
 check device hostdata
To:     huhai <15815827059@163.com>
Cc:     jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        huhai <huhai@kylinos.cn>, stable@vger.kernel.org,
        Jackie Liu <liuyun01@kylinos.cn>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c05aa505e7969ac4"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000c05aa505e7969ac4
Content-Type: text/plain; charset="UTF-8"

The patch could be improved to clear the ata_cmd_pending bit for the
cases !sas_device_priv_data->sas_target and
sas_device_priv_data->sas_target->deleted before returning
DID_NO_CONNECT to retain the current functionality.


On Wed, Aug 31, 2022 at 7:11 PM huhai <15815827059@163.com> wrote:
>
> Friendly ping.
>
>
> At 2022-08-25 17:26:45, "huhai" <15815827059@163.com> wrote:
> >From: huhai <huhai@kylinos.cn>
> >
> >If _scsih_io_done() is called with scmd->device->hostdata=NULL, it can lead
> >to the following panic:
> >
> >  BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> >  PGD 4547a4067 P4D 4547a4067 PUD 0
> >  Oops: 0002 [#1] SMP NOPTI
> >  CPU: 62 PID: 0 Comm: swapper/62 Kdump: loaded Not tainted 4.19.90-24.4.v2101.ky10.x86_64 #1
> >  Hardware name: Storage Server/65N32-US, BIOS SQL1041217 05/30/2022
> >  RIP: 0010:_scsih_set_satl_pending+0x2d/0x50 [mpt3sas]
> >  Code: 00 00 48 8b 87 60 01 00 00 0f b6 10 80 fa a1 74 09 31 c0 80 fa 85 74 02 f3 c3 48 8b 47 38 40 84 f6 48 8b 80 98 00 00 00 75 08 <f0> 80 60 18 fe 31 c0 c3 f0 48 0f ba 68 18 00 0f 92 c0 0f b6 c0 c3
> >  RSP: 0018:ffff8ec22fc03e00 EFLAGS: 00010046
> >  RAX: 0000000000000000 RBX: ffff8eba1b072518 RCX: 0000000000000001
> >  RDX: 0000000000000085 RSI: 0000000000000000 RDI: ffff8eba1b072518
> >  RBP: 0000000000000dbd R08: 0000000000000000 R09: 0000000000029700
> >  R10: ffff8ec22fc03f80 R11: 0000000000000000 R12: ffff8ebe2d3609e8
> >  R13: ffff8ebe2a72b600 R14: ffff8eca472707e0 R15: 0000000000000020
> >  FS:  0000000000000000(0000) GS:ffff8ec22fc00000(0000) knlGS:0000000000000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  CR2: 0000000000000018 CR3: 000000046e5f6000 CR4: 00000000003406e0
> >  Call Trace:
> >   <IRQ>
> >   _scsih_io_done+0x4a/0x9f0 [mpt3sas]
> >   _base_interrupt+0x23f/0xe10 [mpt3sas]
> >   __handle_irq_event_percpu+0x40/0x190
> >   handle_irq_event_percpu+0x30/0x70
> >   handle_irq_event+0x36/0x60
> >   handle_edge_irq+0x7e/0x190
> >   handle_irq+0xa8/0x110
> >   do_IRQ+0x49/0xe0
> >
> >Fix it by move scmd->device->hostdata check before _scsih_set_satl_pending
> >called.
> >
> >Other changes:
> >- It looks clear to move get mpi_reply to near its check.
> >
> >Fixes: ffb584565894 ("scsi: mpt3sas: fix hang on ata passthrough commands")
> >Cc: <stable@vger.kernel.org> # v4.9+
> >Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
> >Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> >Signed-off-by: huhai <huhai@kylinos.cn>
> >---
> > drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +++++++--------
> > 1 file changed, 7 insertions(+), 8 deletions(-)
> >
> >diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >index def37a7e5980..85f5749a0421 100644
> >--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >@@ -5704,27 +5704,26 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
> >       struct MPT3SAS_DEVICE *sas_device_priv_data;
> >       u32 response_code = 0;
> >
> >-      mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
> >-
> >       scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
> >       if (scmd == NULL)
> >               return 1;
> >
> >+      sas_device_priv_data = scmd->device->hostdata;
> >+      if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
> >+           sas_device_priv_data->sas_target->deleted) {
> >+              scmd->result = DID_NO_CONNECT << 16;
> >+              goto out;
> >+      }
> >       _scsih_set_satl_pending(scmd, false);
> >
> >       mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
> >
> >+      mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
> >       if (mpi_reply == NULL) {
> >               scmd->result = DID_OK << 16;
> >               goto out;
> >       }
> >
> >-      sas_device_priv_data = scmd->device->hostdata;
> >-      if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
> >-           sas_device_priv_data->sas_target->deleted) {
> >-              scmd->result = DID_NO_CONNECT << 16;
> >-              goto out;
> >-      }
> >       ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
> >
> >       /*
> >--
> >2.27.0
> >
> >
> >No virus found
> >               Checked by Hillstone Network AntiVirus

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000c05aa505e7969ac4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AYPMVSim4+pTItuq9IB5a3B4lXktI8GoZ4icvNq/tDUC+UQBkiyx41thyEA3MCL+kgpIDnw1yNbe
DuhEcmBxC3E4cziK/swLRngmgXt+5vyInAJZt7HlQxtmx5IEZ4mXQ9lv/ZbRm6xdAgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
pgsVbwKDpO1jbwtH74jMrhpldKgwDQYJKoZIhvcNAQELBQADggEBAAs3g9+OH401HDPcsiK943D1
29CLPOuPWwMLezDdRvDcSqXw/gHia/3hEqnSZiSNEHi7WJ+bhd7c/kLupVhlae5tQwGMchue4U6R
/3Ck8BQ5wivGrL3n0hksKHrXs+pPI96sat0kZCX/OVLJ6KfZoNBnl4lgXkgjfrWs/2U+gcMU2lmw
zhujPHSNF2UIyRNtvcw0NozAtiov/KGLHocfrD39IAsX9SpKaqH6W0lFtOeevTeAg7Y0yXo7HXKY
t+RqMzkDTXFXS6MXhqwXQHf6laWJkR9smRePlZ7BHSurIjHbpKhVaYCd6aKI4gUlq2t/zr+ct4Ls
WZg6a7glbWLB4YExggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx1ZyicYAvHT9A0GRQwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIXU+2SW
PQu2XLxgYnmeTYlxN0SETXH7duuDenfINvrQMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIyMDkwMTA1MDgzMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBO8VQ8jSTJ0ULW4tlhwIB1ihoY
wuh/CMQ9+VXSac6VwwugNPeoPqrVyXVN2/DVqO/uhEjX6WqvztFXEWN4s5AeaKhvbVVfyL7nTlwG
3BdAU5NmGcMoVYL/mSbooBPJmr3i81OBkcHh5C7et3iBvwTA2E6QefgZaCkFebvRgROulC1QZiyc
QBvZPDqpnoQmef97ONXb2VxsYcxKNbRvXAuJdR0IpnAcQS8Y16TA3CGyWRwUWIETT+z/E5XNaAJt
5vKn3ylsZhd9TT9UAmQ5l27hyEM6OLmSls5V1C1efn9G5qYEN+0GdIOgudeeVEEjba+h8jxKiIyC
xu6kBvsO2uDb
--000000000000c05aa505e7969ac4--
