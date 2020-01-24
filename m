Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502D414790A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 08:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgAXHoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 02:44:39 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44918 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAXHoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 02:44:39 -0500
Received: by mail-lj1-f194.google.com with SMTP id q8so1328932ljj.11;
        Thu, 23 Jan 2020 23:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=yxW2BvIvUw0NEz8y4EpZ6DoDk+M25BZxmXggxahFw1g=;
        b=gnM+x3n74rpAuj8+ilXjemyEPgMgi7ylhGw48/s6y/o2IcdFKqGSCOTXmo/b4XGiGA
         XE9f/G0m7OwYm3qZI6DIvcmBYj9DvaDykCarxvsaNKsmuht+ZhEW0zwug0gQ6Xg17Yy+
         UBjQzd5CwFGob7hniQuNnZyXbZx7nk7KLeNoYmiZd/p1w+aNOwf+R5EJPB64GPbIG1t+
         vYWjPHoS5GlqVNdMlPQYn6BrZwyBqYvS43dYdCMJKdBG9KU3kOUfXEjgSJV47Mtrgwil
         45iKP53NanYXFhEXNI78kwhkv1pl/faowLcXlfcE/xmYVE6qM7h6P0Y4KfSnjPnX0TCX
         inBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=yxW2BvIvUw0NEz8y4EpZ6DoDk+M25BZxmXggxahFw1g=;
        b=MXiRWBIpxTQ3XcfuczH95MqP26bj+pGoR0mbSM8fuBqEOs6Hm2Zw4dJ+dzVNGDk0zm
         tXqR2iq9ehKaVO3Myao3vJR3F8vb/y4DoyhuA6tZ3yutR58zuGsYg3rFUbJYktfGPm54
         xZIAOFftJhuhPqZ3p8UCff54hIUputNs6kcQQm7PoisMCeRkCbRJDllbgxefVOe6iUON
         059DM2qSLo4J0O7CQVbnOC2wwFgT629mWV7CIq7hEA3eyRfOfbS8bfp0LdfVYL17yeLt
         vm5mQZJFZfEsEB7SUzJ4UK7iPai5urfLv8il8YlE3IyK61LbvfZy1VqX2sdRWTHmEGXO
         NMvA==
X-Gm-Message-State: APjAAAVeuXW88YA/cgfP5T0vML7HfFcJeEnBuQj3C7nhfa25g1Tc+uJ8
        QzO1XaOXHlpchRt/SY3jJb1BWykNbXg=
X-Google-Smtp-Source: APXvYqx3QeqdqLvwIrCMpjhqINWjT2SyO3R1ILxdGXiqpQni/fpyAAcz4s5Q20xljT+wDeijxENbfA==
X-Received: by 2002:a2e:7d0c:: with SMTP id y12mr1500076ljc.39.1579851875692;
        Thu, 23 Jan 2020 23:44:35 -0800 (PST)
Received: from saruman (88-113-215-33.elisa-laajakaista.fi. [88.113.215.33])
        by smtp.gmail.com with ESMTPSA id p15sm2289704lfo.88.2020.01.23.23.44.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Jan 2020 23:44:34 -0800 (PST)
From:   Felipe Balbi <balbi@kernel.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] usb: dwc3: gadget: Check for IOC/LST bit in both event->status and TRB->ctrl fields
In-Reply-To: <CALAqxLUeBf2Jx2tLW1yzJk6JHM0RP9cJbTt7m19Qdz-rWMw2mQ@mail.gmail.com>
References: <20200122222645.38805-1-john.stultz@linaro.org> <20200122222645.38805-2-john.stultz@linaro.org> <87tv4m4ov2.fsf@kernel.org> <CALAqxLUeBf2Jx2tLW1yzJk6JHM0RP9cJbTt7m19Qdz-rWMw2mQ@mail.gmail.com>
Date:   Fri, 24 Jan 2020 09:45:22 +0200
Message-ID: <87iml147sd.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

John Stultz <john.stultz@linaro.org> writes:

> On Wed, Jan 22, 2020 at 11:23 PM Felipe Balbi <balbi@kernel.org> wrote:
>> > From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
>> >
>> > The present code in dwc3_gadget_ep_reclaim_completed_trb() will check
>> > for IOC/LST bit in the event->status and returns if IOC/LST bit is
>> > set. This logic doesn't work if multiple TRBs are queued per
>> > request and the IOC/LST bit is set on the last TRB of that request.
>> > Consider an example where a queued request has multiple queued TRBs
>> > and IOC/LST bit is set only for the last TRB. In this case, the Core
>> > generates XferComplete/XferInProgress events only for the last TRB
>> > (since IOC/LST are set only for the last TRB). As per the logic in
>> > dwc3_gadget_ep_reclaim_completed_trb() event->status is checked for
>> > IOC/LST bit and returns on the first TRB. This makes the remaining
>> > TRBs left unhandled.
>> > To aviod this, changed the code to check for IOC/LST bits in both
>>      avoid
>>
>> > event->status & TRB->ctrl. This patch does the same.
>>
>> We don't need to check both. It's very likely that checking the TRB is
>> enough.
>
> Sorry, just to clarify, are you suggesting instead of:
> -       if (event->status & DEPEVT_STATUS_IOC)
> +       if ((event->status & DEPEVT_STATUS_IOC) &&
> +           (trb->ctrl & DWC3_TRB_CTRL_IOC))
>
>
> We do something like:
> -       if (event->status & DEPEVT_STATUS_IOC)
> +       if (trb->ctrl & DWC3_TRB_CTRL_IOC)
> +               return 1;
> +
> +       if (trb->ctrl & DWC3_TRB_CTRL_LST)
>                 return 1;
>
> ?

that's correct. In hindsight, I have no idea why I used the
event->status here since all other checks are done against the TRB
only.

>> > At a practical level, this patch resolves USB transfer stalls seen
>> > with adb on dwc3 based HiKey960 after functionfs gadget added
>> > scatter-gather support around v4.20.
>>
>> Right, I remember asking for tracepoint data showing this problem
>> happening. It's the best way to figure out what's really going on.
>>
>> Before we accept these two patches, could you collect dwc3 tracepoint
>> data and share here?
>
> Sure. Attached is trace logs and regdumps for hikey960.

Thanks

> The one gotcha with the logs is that in the working case (with this
> patch applied), I booted with the usb-c cable disconnected (as
> suggested in the dwc3.rst doc), enabled tracing and plugged in the
> device, then ran adb logcat a few times to validate no stalls.
>
> In the failure case (without this patch), I booted with the usb-c
> cable disconnected, enabled tracing and then when I plugged in the
> device, it never was detected by adb (it seems perhaps the problem had
> already struck?).

You never got a Reset Interrupt, so something else is going on. I
suggest putting a sniffer and first making sure the host *does* drive
reset signalling. Second step would be to look at your phy
configuration. Is it going in suspend for any reason? Might want to try
our snps,dis_u3_susphy_quirk and snps,dis_u2_susphy_quirk flags.

> So I generated the failure2 log by booting with USB-C plugged in,
> enabling tracing, and running adb logcat on the host to observe the
> stall.

Thank you. Here's a quick summary of what's in failure2:

There is a series of 24-byte transfers on ep1out and that's the one
which shows a problem. We can clearly see that adb is issuing one
transfer at a time, only enqueueing transfer n+1 when transfer n is
completed and given back, so we see a series of similar blocks:

=2D dwc3_alloc_request
=2D dwc3_ep_queue
=2D dwc3_prepare_trb
=2D dwc3_prepare_trb (for the chained bit)
=2D dwc3_gadget_ep_cmd (update transfer)
=2D dwc3_event (transfer in progress)
=2D dwc3_complete_trb
=2D dwc3_complete_trb (for the chained bit)
=2D dwc3_gadget_giveback
=2D dwc3_free_request

So this works for several iterations. Note, however, that the TRB
addresses don't really make sense. DWC3 allocates a contiguous block of
memory to server as TRB pool, but we see non-consecutive addresses on
these TRBs. I'm assuming there's an IOMMU in your system.

Anyway, the failing point is here:

>          adbd-461   [002] d..1    49.855992: dwc3_alloc_request: ep1out: =
req 000000004e6eaaba length 0/0 zsI =3D=3D> 0
>          adbd-461   [002] d..2    49.855994: dwc3_ep_queue: ep1out: req 0=
00000004e6eaaba length 0/24 zsI =3D=3D> -115
>          adbd-461   [002] d..2    49.855996: dwc3_prepare_trb: ep1out: tr=
b 00000000bae39b48 buf 000000009eb0b100 size 24 ctrl 0000001d (HlCS:sc:norm=
al)
>          adbd-461   [002] d..2    49.855997: dwc3_prepare_trb: ep1out: tr=
b 000000009093a074 buf 0000000217da8000 size 488 ctrl 00000819 (HlcS:sC:nor=
mal)
>          adbd-461   [002] d..2    49.856003: dwc3_gadget_ep_cmd: ep1out: =
cmd 'Update Transfer' [20007] params 00000000 00000000 00000000 --> status:=
 Successful
>   irq/65-dwc3-498   [000] d..1    53.902752: dwc3_event: event (00006084)=
: ep1out: Transfer In Progress [0] (SIm)
>   irq/65-dwc3-498   [000] d..1    53.902763: dwc3_complete_trb: ep1out: t=
rb 00000000bae39b48 buf 000000009eb0b100 size 0 ctrl 0000001c (hlCS:sc:norm=
al)
>   irq/65-dwc3-498   [000] d..1    53.902769: dwc3_complete_trb: ep1out: t=
rb 000000009093a074 buf 0000000217da8000 size 488 ctrl 00000819 (HlcS:sC:no=
rmal)
>   irq/65-dwc3-498   [000] d..1    53.902781: dwc3_gadget_giveback: ep1out=
: req 000000004e6eaaba length 24/24 zsI =3D=3D> 0
> kworker/u16:0-7     [000] ....    53.903020: dwc3_free_request: ep1out: r=
eq 000000004e6eaaba length 24/24 zsI =3D=3D> 0
>          adbd-461   [002] d..1    53.903273: dwc3_alloc_request: ep1out: =
req 00000000c769beab length 0/0 zsI =3D=3D> 0
>          adbd-461   [002] d..2    53.903285: dwc3_ep_queue: ep1out: req 0=
0000000c769beab length 0/24 zsI =3D=3D> -115
>          adbd-461   [002] d..2    53.903292: dwc3_prepare_trb: ep1out: tr=
b 00000000f0ffa827 buf 000000009eb11e80 size 24 ctrl 0000001d (HlCS:sc:norm=
al)
>          adbd-461   [002] d..2    53.903296: dwc3_prepare_trb: ep1out: tr=
b 00000000d6a9892a buf 0000000217da8000 size 488 ctrl 00000819 (HlcS:sC:nor=
mal)
>          adbd-461   [002] d..2    53.903315: dwc3_gadget_ep_cmd: ep1out: =
cmd 'Update Transfer' [20007] params 00000000 00000000 00000000 --> status:=
 Successful

Note that this transfer, after started, took 4 seconds to complete,
while all others completed within a few ms. There's no real reason for
this visible from dwc3 driver itself. What follows, is a transfer that
never completed.

The only thing I can come up with, is that we starve the TRB ring, by
continuously reclaiming a single TRB. We have 255 usable TRBs, so after
a few iterations, we would see a stall due to starved TRB ring.

There is a way to verify this by tracking trb_enqueue and trb_dequeue,
if you're willing to do that, that'll help us prove that this is really
the problem and, since current tracepoints doen't really show that
information, it may be a good idea to add this information to
dwc3_log_trb tracepoint class. Something like below should be enough,
could you re-run the test of failure2 with this patch applied?

drivers/usb/dwc3/trace.h | 9 +++++++--

modified   drivers/usb/dwc3/trace.h
@@ -227,6 +227,8 @@ DECLARE_EVENT_CLASS(dwc3_log_trb,
 		__field(u32, size)
 		__field(u32, ctrl)
 		__field(u32, type)
+		__field(u32, enqueue)
+		__field(u32, dequeue)
 	),
 	TP_fast_assign(
 		__assign_str(name, dep->name);
@@ -236,9 +238,12 @@ DECLARE_EVENT_CLASS(dwc3_log_trb,
 		__entry->size =3D trb->size;
 		__entry->ctrl =3D trb->ctrl;
 		__entry->type =3D usb_endpoint_type(dep->endpoint.desc);
+		__entry->enqueue =3D dep->trb_enqueue
+		__entry->dequeue =3D dep->trb_dequeue
 	),
=2D	TP_printk("%s: trb %p buf %08x%08x size %s%d ctrl %08x (%c%c%c%c:%c%c:%=
s)",
=2D		__get_str(name), __entry->trb, __entry->bph, __entry->bpl,
+	TP_printk("%s: trb %p (E%d:D%d) buf %08x%08x size %s%d ctrl %08x (%c%c%c%=
c:%c%c:%s)",
+		__get_str(name), __entry->trb, __entry->enqueue,
+		__entry->dequeue, __entry->bph, __entry->bpl,
 		({char *s;
 		int pcm =3D ((__entry->size >> 24) & 3) + 1;
 		switch (__entry->type) {

> Anyway, all three sets of logs are included. Let me know if you need
> me to try anything else.

Thanks for doing this

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl4qoJIACgkQzL64meEa
mQZKjxAAjgCcPuicCwxc4CKu4/WxEDTNfnMZ62B1/FwNqgD09cl+kaT8dfVpVpxu
BBWgb14fZWDK5vL0kSn/bD1ljjrd8nrL2XEj+r6j1A0KgFq+y0ssMdwQXxSGWjaY
HgpHfaN9QXxVC8MTRkUOC7XTwgZz5bVKrSOkIH3uOXso4Rqp+zX1D9rxYtemn3xp
ugHD+COKpRPqWFq4I89fNCIeA8Y9X+6b9TwZH6UvwPfc6M0WRLTdRCP1M6s4e40n
t341dtbPANouLey98xR5g58ANUOOHsX5Ke2CrrfkS0vzmqVLiI3kwHOEyUFnLzh0
fIGRFF5GMUCjK+LcVUl9By3pnLh2QM5M5RLst6LwX8XihqViYgYbwmVedJ8XqQdK
ldehvHZFU511AHTJAMM3nUwdONWM2umgR7vWV6hQAn3IOGRyurbqx4isHw085dj5
doDVnH4l68GEvH1EitesWhPLV9A6H6x/0IrF5xfsnLWiAcWBWwwygO4H61FDo0wV
yg4goL0w8+jLpsIP56nGDHzmIGSzKC+QNwd4CmX0U5ZAiTtJUo0/+QH0t1XtWt5W
Tdf8RizsCXIaitbWtQiCfzMySpHkU49mx3CchRQ9jVdvDtZwO2H7H+Ajqp0mxt2I
vC/6/bUNQCDVFAItF33JWx9yaGzyV9ifLOdYSmbTDL139XQ/ncg=
=APiK
-----END PGP SIGNATURE-----
--=-=-=--
