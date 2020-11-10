Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796352ADE4C
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 19:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbgKJS3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 13:29:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731220AbgKJS3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 13:29:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605032955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFrydsLzyqWSxiM27mwWcOUP0PeGSKJQY1k6JClvWC8=;
        b=c5qkZI2iDdIxw82haAuziF0ZAqYxgwGDULIEmQBDf9+1NhbtPUe0BPm4t0DLy5ZpJ/OiL2
        NxSxcFXv42S8PqWLyyqftHjJonhGsXVBhF1jEMLjQ12fi/i8GRjvMddm4nydgYDPwPz4Cy
        DppRkieULl3IqRp0MQ2y1DE2Fq5AEhg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-GxkRJrxBN0youu5U_ZxqOQ-1; Tue, 10 Nov 2020 13:29:14 -0500
X-MC-Unique: GxkRJrxBN0youu5U_ZxqOQ-1
Received: by mail-wr1-f69.google.com with SMTP id w6so6024596wrk.1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 10:29:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CFrydsLzyqWSxiM27mwWcOUP0PeGSKJQY1k6JClvWC8=;
        b=o58AxVBwM9v4/q6aRB+ysFgr1viUAt3Q6apV7pihgcLpMM5LMmQRfkaCjSC+u+5/ac
         T9wUMvbHxPx5Rsael43QZGisAFmq3Mr1vgq90jKR61MXwajy/p3lYKCdSc4pia3wNn/I
         IeSJCrwrm9OCpHWh9uBhY8gjIwDM8Hh+fQZ1wcIl6y97vbI+MehuzrWSUHRGcPlcdaxW
         NnbiBDV0NFoa2ppMvDQhMO5yE9O7WGAvN3JgEGne+yB2abj19ZGBqhhNvxWV8OGLSJ1a
         xPqiU65Q9dPul7Ro19JX3d+Y4UTF+tZrfuEHpDyM4ihhWLo61wwVa78181/1XCF4fU+U
         Gd1A==
X-Gm-Message-State: AOAM532yOuaemMs6WhUkv3JHMiLfQNDFXMHrdtkqKGMY4Xx02PgihvEw
        VO3djzwnkTZr0VB7pRL6vzfjGdF8cqyyleSZ04SXo9r5uceEf5DeQ5TrDD9+v6uDbUTMjYNWV8I
        l5tAOpR1K+xxWoA7ZojQpOUtbxzFlV6wCs20/PaP6Upvpz6ryTxL9XTGXYva40bbzKtWmn+UXc8
        PnWywJug==
X-Received: by 2002:a5d:4e0e:: with SMTP id p14mr24883058wrt.160.1605032952441;
        Tue, 10 Nov 2020 10:29:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUgkVgHDHO+mFlrFPlPA0jPUwTRB3U9RpClrP6YxhJk/ns+BvM4SYBgqaBJEBQzAzNQUZbkg==
X-Received: by 2002:a5d:4e0e:: with SMTP id p14mr24883026wrt.160.1605032952062;
        Tue, 10 Nov 2020 10:29:12 -0800 (PST)
Received: from ?IPv6:2a01:e34:eea6:7961:1234::1ba? ([2a01:e34:eea6:7961:1234::1ba])
        by smtp.gmail.com with ESMTPSA id 34sm20315913wrq.27.2020.11.10.10.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 10:29:11 -0800 (PST)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH 1/3] HID: logitech-dj: Handle quad/bluetooth keyboards
 with a builtin trackpad
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
References: <20201102133658.4410-1-hdegoede@redhat.com>
 <e3817ab8-906e-cb98-91db-ffb4cc821788@redhat.com>
Message-ID: <ab1788a1-1f23-45bd-72e8-fadcea82514f@redhat.com>
Date:   Tue, 10 Nov 2020 19:29:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <e3817ab8-906e-cb98-91db-ffb4cc821788@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,

On Tue, Nov 10, 2020 at 2:17 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi All,
>
> On 11/2/20 2:36 PM, Hans de Goede wrote:
> > Some quad/bluetooth keyboards, such as the Dinovo Edge (Y-RAY81) have a
> > builtin touchpad. In this case when asking the receiver for paired devices,
> > we get only 1 paired device with a device_type of REPORT_TYPE_KEYBOARD.
> >
> > This means that we do not instantiate a second dj_hiddev for the mouse
> > (as we normally would) and thus there is no place for us to forward the
> > mouse input reports to, causing the touchpad part of the keyboard to not
> > work.
> >
> > There is no way for us to detect these keyboards, so this commit adds
> > an array with device-ids for such keyboards and when a keyboard is on
> > this list it adds STD_MOUSE to the reports_supported bitmap for the
> > dj_hiddev created for the keyboard fixing the touchpad not working.
> >
> > Using a list of device-ids for this is not ideal, but there are only
> > very few such keyboards so this should be fine. Besides the Dinovo Edge,
> > other known wireless Logitech keyboards with a builtin touchpad are:
> >
> > * Dinovo Mini (TODO add its device-id to the list)
> > * K400 (uses a unifying receiver so is not affected)
> > * K600 (uses a unifying receiver so is not affected)
> >
> > Cc: stable@vger.kernel.org
> > BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1811424
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>
> ping? This is a bug fix for a regression caused by:

Series looks good. I tried to enable the Dinovo Mini this afternoon (see
patch below), but it's not that clean and easy...

>
> Commit f2113c3020ef ("HID: logitech-dj: add support for Logitech Bluetooth Mini-Receiver")
>
> Specifically that commit caused the builtin touchpad to stop working on Logitech Dinovo
> Edge keyboards and this fixes this.
>
> I realize now that I forgot to add a:
>
> Fixes: f2113c3020ef ("HID: logitech-dj: add support for Logitech Bluetooth Mini-Receiver")
>
> Tag, let me know if you want a v2 for that.

I guess you want the tag on all 3 patches, not just the first.

If so, I can try to push it later today or tomorrow.


>
> Regardless since this is a bug fix, it would be good if we can get this
> merged into one of the upcoming 5.10-rc#s. Even without the Dinovo Mini
> id added this is still worthwhile to get the reported regression fixed
> and we can add the Dinovo Mini id later.

Yeah, the Dinovo Mini will come later.

My current WIP is the following:

---

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 1cafb65428b0..1c7857bf3290 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -84,6 +84,7 @@
  #define STD_MOUSE				BIT(2)
  #define MULTIMEDIA				BIT(3)
  #define POWER_KEYS				BIT(4)
+#define BT_MOUSE				BIT(5)
  #define MEDIA_CENTER				BIT(8)
  #define KBD_LEDS				BIT(14)
  /* Fake (bitnr > NUMBER_OF_HID_REPORTS) bit to track HID++ capability */
@@ -333,6 +334,47 @@ static const char mse_bluetooth_descriptor[] = {
  	0xC0,			/*  END_COLLECTION                      */
  };
  
+/* Mouse descriptor (5) for Bluetooth receiver, low-res hwheel, 8 buttons */
+static const char mse5_bluetooth_descriptor[] = {
+	0x05, 0x01,		/*  USAGE_PAGE (Generic Desktop)        */
+	0x09, 0x02,		/*  Usage (Mouse)                       */
+	0xa1, 0x01,		/*  Collection (Application)            */
+	0x85, 0x05,		/*   Report ID (5)                      */
+	0x09, 0x01,		/*   Usage (Pointer)                    */
+	0xa1, 0x00,		/*   Collection (Physical)              */
+	0x05, 0x09,		/*    Usage Page (Button)               */
+	0x19, 0x01,		/*    Usage Minimum (1)                 */
+	0x29, 0x08,		/*    Usage Maximum (8)                 */
+	0x15, 0x00,		/*    Logical Minimum (0)               */
+	0x25, 0x01,		/*    Logical Maximum (1)               */
+	0x95, 0x08,		/*    Report Count (8)                  */
+	0x75, 0x01,		/*    Report Size (1)                   */
+	0x81, 0x02,		/*    Input (Data,Var,Abs)              */
+	0x05, 0x01,		/*    Usage Page (Generic Desktop)      */
+	0x16, 0x01, 0xf8,	/*    Logical Minimum (-2047)           */
+	0x26, 0xff, 0x07,	/*    Logical Maximum (2047)            */
+	0x75, 0x0c,		/*    Report Size (12)                  */
+	0x95, 0x02,		/*    Report Count (2)                  */
+	0x09, 0x30,		/*    Usage (X)                         */
+	0x09, 0x31,		/*    Usage (Y)                         */
+	0x81, 0x06,		/*    Input (Data,Var,Rel)              */
+	0x15, 0x81,		/*    Logical Minimum (-127)            */
+	0x25, 0x7f,		/*    Logical Maximum (127)             */
+	0x75, 0x08,		/*    Report Size (8)                   */
+	0x95, 0x01,		/*    Report Count (1)                  */
+	0x09, 0x38,		/*    Usage (Wheel)                     */
+	0x81, 0x06,		/*    Input (Data,Var,Rel)              */
+	0x05, 0x0c,		/*    Usage Page (Consumer Devices)     */
+	0x0a, 0x38, 0x02,	/*    Usage (AC Pan)                    */
+	0x15, 0x81,		/*    Logical Minimum (-127)            */
+	0x25, 0x7f,		/*    Logical Maximum (127)             */
+	0x75, 0x08,		/*    Report Size (8)                   */
+	0x95, 0x01,		/*    Report Count (1)                  */
+	0x81, 0x06,		/*    Input (Data,Var,Rel)              */
+	0xc0,			/*   End Collection                     */
+	0xc0,			/*  End Collection                      */
+};
+
  /* Gaming Mouse descriptor (2) */
  static const char mse_high_res_descriptor[] = {
  	0x05, 0x01,		/*  USAGE_PAGE (Generic Desktop)        */
@@ -877,6 +919,10 @@ static const u16 kbd_builtin_touchpad_ids[] = {
  	0xb309, /* Dinovo Edge */
  };
  
+static const u16 kbd_builtin_touchpad5_ids[] = {
+	0xb30c, /* Dinovo Mini */
+};
+
  static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
  					    struct hidpp_event *hidpp_report,
  					    struct dj_workitem *workitem)
@@ -901,6 +947,12 @@ static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
  				break;
  			}
  		}
+		for (i = 0; i < ARRAY_SIZE(kbd_builtin_touchpad5_ids); i++) {
+			if (id == kbd_builtin_touchpad5_ids[i]) {
+				workitem->reports_supported |= BT_MOUSE;
+				break;
+			}
+		}
  		break;
  	case REPORT_TYPE_MOUSE:
  		workitem->reports_supported |= STD_MOUSE | HIDPP;
@@ -1368,6 +1420,13 @@ static int logi_dj_ll_parse(struct hid_device *hid)
  			      sizeof(mse_descriptor));
  	}
  
+	if (djdev->reports_supported & BT_MOUSE) {
+		dbg_hid("%s: sending a mouse descriptor, reports_supported: %llx\n",
+			__func__, djdev->reports_supported);
+		rdcat(rdesc, &rsize, mse5_bluetooth_descriptor,
+		      sizeof(mse5_bluetooth_descriptor));
+	}
+
  	if (djdev->reports_supported & MULTIMEDIA) {
  		dbg_hid("%s: sending a multimedia report descriptor: %llx\n",
  			__func__, djdev->reports_supported);
@@ -1907,6 +1966,14 @@ static const struct hid_device_id logi_dj_receivers[] = {
  	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
  		0xc71c),
  	 .driver_data = recvr_type_bluetooth},
+	{ /* Logitech DiNovo Mini HID++ / bluetooth receiver mouse intf. */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
+		0xc71e),
+	 .driver_data = recvr_type_bluetooth},
+	{ /* Logitech DiNovo Mini HID++ / bluetooth receiver keyboard intf. */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
+		0xc71f),
+	 .driver_data = recvr_type_bluetooth},
  	{}
  };
  
---

And the keyboard is not sending the proper KEY_MEDIA like with the
hid-logitech.ko driver. So this WIP can not go into a stable tree.

Cheers,
Benjamin

