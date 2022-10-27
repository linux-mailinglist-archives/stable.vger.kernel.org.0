Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCDD60F22E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 10:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbiJ0IWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 04:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiJ0IWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 04:22:17 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697861CB0C
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 01:22:16 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id v125-20020a1cac83000000b003bd44dc5242so2435232wme.7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 01:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ensG1aiR3XdykM/MMnZ7AX9t3z19jrp54YzAQQKGlWM=;
        b=lnpIL7VslzlRJbzuderEmAOsPoRXbiibZv66kEBy6IhZrZnfE4fJZw1iR8b+G0q0jt
         AN5Td/lm7nMnmKdkFYxxNEQIGYnRAw+CaR1K6iWLCLJ11S9wFfIr48yn39iAA4q0LYPp
         61dufNxAmKmCd7RZs6WHICF2YKxtKYF7nMeJfzaynKa7lcj0shP4ywxSTVRlPReQ2ZKX
         ft6PeNfB/TlQmw5nTgPmiCrBjAdG6uCiiHQOdd62K8Ii/XQGakNz/ego93Vcvl2KPXGh
         gic4GRNaIDW+Qj70Xt9wRwvBbdmcFn2ulfg5icj+izOpf+lhPTVGsdue8UNsRn+cbLa3
         hVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ensG1aiR3XdykM/MMnZ7AX9t3z19jrp54YzAQQKGlWM=;
        b=wvsnN0f1vLuUfFFnxUevmVzOLwHolM1BWaLKQncyQF6ZZpIPZcRdKqozWe3VwQNkgX
         nO1JqnODUntbaVuSjIMvIa0RJpXMalXMjWcQ+1j10x4Ku2g+W5aV4fxW3Zh0+XGSdKUy
         AXptYQEFMKF0CxGTFVq9s/z+xDKg5etN0k/wBivrn5GVDGsZJ0ilIlo1f6s/HjraD/DR
         zk3ZGvieyZ1yLrdd3baoXEFpu8dGcpUqMY9cXvQHpPfPVBUX1kSIakluEkv+yiTw7nK0
         1O4ZlRBqscuH0CVsns3iPRmbRW5CvOiNaREua7xONhN52kXgVgbszzISe7Hij3FMiHKB
         QmdQ==
X-Gm-Message-State: ACrzQf24jd6paqLJKyzSsAvNkICju43cYyzrP38GWiu5JllhjuF8As8r
        kH6D9XduyDmcmXusX9lXDpYH5se0GRsDQw==
X-Google-Smtp-Source: AMsMyM6YKAUi11plTcv/GZk/2qkkYniLriFmWr7/wVtq1DYO5u3t6JriCMQweQLE9Z/kpdkchOuHw4RmTqO0IQ==
X-Received: from bistanclaque.zrh.corp.google.com ([2a00:79e0:42:204:34aa:3c10:4b35:5e84])
 (user=ndumazet job=sendgmr) by 2002:a05:6000:1689:b0:22e:2c03:36e7 with SMTP
 id y9-20020a056000168900b0022e2c0336e7mr32732679wrd.252.1666858934879; Thu,
 27 Oct 2022 01:22:14 -0700 (PDT)
Date:   Thu, 27 Oct 2022 10:22:08 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221027082208.25483-1-ndumazet@google.com>
Subject: [PATCH] usb: add NO_LPM quirk for Realforce 87U Keyboard
From:   Nicolas Dumazet <ndumazet@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Cc:     Petar Kostic <petar@kostic.dev>, Oliver Neukum <oneukum@suse.com>,
        Ole Ernst <olebowle@gmx.com>,
        Hannu Hartikainen <hannu@hrtk.in>,
        Jimmy Wang <wangjm221@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Dumazet <ndumazet@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before adding this quirk, this (mechanical keyboard) device would not be
recognized, logging:

  new full-speed USB device number 56 using xhci_hcd
  unable to read config index 0 descriptor/start: -32
  chopping to 0 config(s)

It would take dozens of plugging/unpuggling cycles for the keyboard to
be recognized. Keyboard seems to simply work after applying this quirk.

This issue had been reported by users in two places already ([1], [2])
but nobody tried upstreaming a patch yet. After testing I believe their
suggested fix (DELAY_INIT + NO_LPM + DEVICE_QUALIFIER) was probably a
little overkill. I assume this particular combination was tested because
it had been previously suggested in [3], but only NO_LPM seems
sufficient for this device.

[1]: https://qiita.com/float168/items/fed43d540c8e2201b543
[2]: https://blog.kostic.dev/posts/making-the-realforce-87ub-work-with-usb30-on-Ubuntu/
[3]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1678477

Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Dumazet <ndumazet@google.com>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 0722d2131305..e775d1bbea4d 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -532,6 +532,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Realforce 87U Keyboard */
+	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
+
 	{ }  /* terminating entry must be last */
 };
 
-- 
2.38.0.135.g90850a2211-goog

